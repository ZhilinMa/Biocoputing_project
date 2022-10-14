#Usage: bash gene1_finder_gene2_counter.sh "gene1" "gene2"
#for this project, gene1 is mcrA and gene2 is hsp70
#this code must be run inside the biocomputing_project directory in a CRC FE machine with the default setup we were told to use
#(after changing the name of the cloned directory to biocomputing_project_1 so it is spelled right and has no spaces or capitalization to deal with)
#So muscle, hmmrbuild, and hmmrsearch should be in ~/Private/Biocomputing2022/tools, and the biocomputing_project directory is in ~/Private/Biocomputing2022/biocomputing_project

#we are going to make a lot of files in the course of this that we might want later, but do not want in the way, so we will make a directory for them
mkdir script_byproducts_for_"$1"_and_"$2"_search
cd script_byproducts_for_"$1"_and_"$2"_search

#the first thing you need to do is combine all the ref sequences for each gene into one file (per gene) so you can use muscle to align the sequences
cat ~/Private/Biocomputing2022/biocomputing_project_1/ref_sequences/"$1"gene_*.fasta > combined_"$1"_ref_sequences.fasta
cat ~/Private/Biocomputing2022/biocomputing_project_1/ref_sequences/"$2"gene_*.fasta > combined_"$2"_ref_sequences.fasta

#then align the sequences using muscle for both the reference McrA sequences and the reference Hsp70 sequences and store the aligned versions in files
~/Private/Biocomputing2022/tools/muscle -in combined_"$1"_ref_sequences.fasta -out "$1"_aligned.afa
~/Private/Biocomputing2022/tools/muscle -in combined_"$2"_ref_sequences.fasta -out "$2"_aligned.afa

#then you need to use the aligned files to generate/build  profiles to search for using hmmbuild
~/Private/Biocomputing2022/tools/hmmbuild --amino "$1"_hmm_built_profile.fasta "$1"_aligned.afa
~/Private/Biocomputing2022/tools/hmmbuild --amino "$2"_hmm_built_profile.fasta "$2"_aligned.afa


#after that, you need to search the proteomes for the McrA sequence.  If they do not have it, they can be discarded from consideration because the bacteria they are from are not methanogenic bacteria.
#So first we are going to copy the entire proteome folder so that we can just remove the non-methanogenic proteomes in the copy without permanently deleting them since we'll still have the original
cp -R ~/Private/Biocomputing2022/biocomputing_project_1/proteomes ~/Private/Biocomputing2022/biocomputing_project_1/"$1"ogenic_proteomes


#then for each proteome, we search for McrA sequence matches, count the number of matches using grep, and then rename the file with the number of matches so we can delete the useless ones with 0
for file in ~/Private/Biocomputing2022/biocomputing_project_1/"$1"ogenic_proteomes/*.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$file"_"$1"_search.txt "$1"_hmm_built_profile.fasta "$file"
num_hits="$(grep -c -v '#' "$file"_"$1"_search.txt)"
mv "$file"_"$1"_search.txt "$file"_"$1"_search_with"$num_hits"hits.txt
done

#then we find all the ones with 0 matches and delete them
echo ~/Private/Biocomputing2022/biocomputing_project_1/"$1"ogenic_proteomes/*_"$1"_search_with0hits.txt > non"$1"ogenic_proteomes.txt
grep -o "proteome_[0-9][0-9].fasta" non"$1"ogenic_proteomes.txt > non"$1"ogenic_bacteria.txt
rm non"$1"ogenic_proteomes.txt

while read entry
do
rm ~/Private/Biocomputing2022/biocomputing_project_1/"$1"ogenic_proteomes/*$entry*
done <non"$1"ogenic_bacteria.txt
rm non"$1"ogenic_bacteria.txt

#once you have discarded the non-methanogenic bacteria, you need to find those that can live in an acidic environment by looking for Hsp70 sequences in their proteomes.
#first you search for the Hsp70 sequence in all of the remaining proteomes using the Hsp70 profile you constructed earlier, using --tblout to get only the relevant data
#you can use grep to count the matches, then put each proteome name and the number of matches in a file
#then you need to sort the file full of proteomes to see which has the most good matches, which will be the one with the most Hsp70-type sequences and will be the most resistant to acid

for file in ~/Private/Biocomputing2022/biocomputing_project_1/"$1"ogenic_proteomes/*.fasta
do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$file"_"$2"_search.txt "$2"_hmm_built_profile.fasta "$file"
var="$(grep -c -v '#' "$file"_"$2"_search.txt)"
echo "$file" "$var" >> "$2"_matches_per_proteome.txt
done

echo "The "$1"ogenic candidates, in order from most to least "$2" type proteins, (with their count listed at right) are:" > candidates.txt
cat "$2"_matches_per_proteome.txt | sort -t " " -k 2 -n -r | grep -o "proteome_[0-9][0-9].fasta [0-9]\+" | grep -v "fasta 0" >> candidates.txt
rm "$2"_matches_per_proteome.txt

#and then we'll copy these results to the main (biocomputing_project_1) folder so they are easy to find
cp candidates.txt ../gene_finding_counting_candidates_for_"$1"_"$2"_search.txt

cat ~/Private/Biocomputing2022/biocomputing_project_1/"$1"ogenic_proteomes/*search.txt > Collated_Search_Results_for_Both_Genes.txt
#and then you're done
