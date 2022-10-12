# Jacob Hepler jhepler2@nd.edu
# Nolan Sinnaeve nsinnaev@nd.edu

# Usage: bash project.sh
# Assume project.sh is in same directory as the proteomes, mcraproteomes, and hsp70proteomes directories
# Assume hmmbuild, hmmsearch, and muscle are in the correct locations
# First, we need to combine the mcrA.fasta files and the HSP70.fasta files into two separate files

cat ref_sequences/hsp70*.fasta >> refs_hsp70.fasta;
cat ref_sequences/mcrA*.fasta >> refs_mcrA.fasta;

# Next, we need to use muscle to create aligned reference sequences for each type of genes.
~/Private/Biocomputing2022/tools/muscle -in refs_hsp70.fasta -out arefs_hsp70.fasta;
~/Private/Biocomputing2022/tools/muscle -in refs_mcrA.fasta -out arefs_mcrA.fasta;

# remove the refs files
rm refs_hsp70.fasta
rm refs_mcrA.fasta
# Next, we need to use hmmbuild to create the search image 
~/Private/Biocomputing2022/tools/hmmbuild hmmrefs_hsp70.fasta arefs_hsp70.fasta;
~/Private/Biocomputing2022/tools/hmmbuild hmmrefs_mcrA.fasta arefs_mcrA.fasta;

#remove the arefs files to keep the directory clean
rm arefs_hsp70.fasta
rm arefs_mcrA.fasta

# Next, we need to use hmmsearch to search through each proteome for mcrA and hsp70
for file in proteomes/*.fasta
do
	~/Private/Biocomputing2022/tools/hmmsearch --tblout hsp70${file} hmmrefs_hsp70.fasta $file;
done
for file in proteomes/*.fasta
do
	~/Private/Biocomputing2022/tools/hmmsearch --tblout mcra${file} hmmrefs_mcrA.fasta $file;
done

#delete hmmrefs files
rm hmmrefs_hsp70.fasta
rm hmmrefs_mcrA.fasta

# delete previous text run
if [ -f "finaltable.txt" ];
   then rm finaltable.txt
fi

# Finally, we will create a table to organize and sort the results

# headers
echo "Candidate pH-resistant Methanogens" >> finaltable.txt
echo "-----------------------" >> finaltable.txt
echo "proteome | mcrA | hsp70" >> finaltable.txt
echo "-----------------------" >> finaltable.txt

# data
for file in proteomes/*.fasta
do
	mcra=$(cat mcra${file} | grep "WP" | wc -l)
	hsp70=$(cat hsp70${file} | grep "WP" | wc -l)
	name=${file:10:11}
	echo "$name|$mcra|$hsp70" >> table.txt
done

# sorting first by most mcrA count and then by most hsp70 count
cat table.txt | grep -E '\|[1-9]\|[1-9]' | sort -t '|' -k2,2nr -k3,3nr >> finaltable.txt

# remove table.txt
rm table.txt
