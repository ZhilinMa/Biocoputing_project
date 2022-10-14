# Laurel Lown 
# Andrew Lupinski
# Matthew Hawkins

# Shell Script for Biocomputing Project #1 FINAL
### All code is presumed to be in the specified directories.

# This shell script will search each genome (proteome) for the genes of interest (mcrA and HSP70)
# Then, it will produce a summary table collating the results of all searches
# The final output will be a .csv file that will contain a list of the candidate pH-resistant methanogens based on the results.

# Usage: bash run1.sh 
# Make sure script is in the correct working directories (in our case, the ref_sequences directory)

# First, you need to combine the mcrA reference sequences into one single reference file

for file in mcrAgene_**.fasta
do
cat $file >> allmcra.fasta
done

# Next, repeat the step for the HSP70 reference sequences

for file in hsp70gene_**.fasta
do
cat $file >> allhsp70.fasta
done

# To align the reference sequences, use the muscle tool to output one aligned sequence
# Repeated for both mcrA genes and HSP70 genes.

/afs/crc.nd.edu/user/l/llown/Private/Biocomputing2022/Tools/muscle -in allmcra.fasta -out mcrareadyforhmmbuild
/afs/crc.nd.edu/user/l/llown/Private/Biocomputing2022/Tools/muscle -in allhsp70.fasta -out hsp70readyforhmmbuild

# To build a profile HMM file from the sequence alignment from muscle, use the hmmbuild tool 

/afs/crc.nd.edu/user/l/llown/Private/Biocomputing2022/Tools/hmmbuild mcrareadyforhmmsearch mcrareadyforhmmbuild
/afs/crc.nd.edu/user/l/llown/Private/Biocomputing2022/Tools/hmmbuild hsp70readyforhmmsearch hsp70readyforhmmbuild

# From here, create a new file that will contain the output from the next steps

echo -e "create new file" > final.csv

# To search a sequence database with the profile HMM created from hmmbuild, use the hmmsearch tool
# Outputs will be saved into 'final.csv' created in previous step

for file in /afs/crc.nd.edu/user/l/llown/Private/Biocomputing_project/proteomes/proteome_**.fasta
do
/afs/crc.nd.edu/user/l/llown/Private/Biocomputing2022/Tools/hmmsearch --tblout $file.out mcrareadyforhmmsearch $file
A=$(cat $file.out | grep -c "WP")
/afs/crc.nd.edu/user/l/llown/Private/Biocomputing2022/Tools/hmmsearch --tblout $file.out hsp70readyforhmmsearch $file
B=$(cat $file.out | grep -c "WP")
echo -e $file "$A" "$B">> final.csv
done


# To create a table that displays the candidate pH-resistant methanogens based on the presence of mcrA and number of HSP70 matches

cat final.csv | sed 's/\/afs\/crc\.nd\.edu\/user\/l\/llown\/Private\/Biocomputing\_project\/proteomes\///g' | sed 's/\.fasta//g' | sed 's/ [1-9] / Yes /g' | sed 's/ [0] / No /g' | grep -E 'Yes [1-9]' > final.txt


