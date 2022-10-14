#Usage: run this code inside the biocomputing_project directory in a CRC FE machine with the default setup we were told to use (after changing the name of the cloned directory to biocomputing_project_1
#so it is spelled right and has no spaces or capitalization to deal with)
#So muscle, hmmrbuild, and hmmrsearch should be in ~/Private/Biocomputing2022/tools, and the biocomputing_project directory is in ~/Private/Biocomputing2022/biocomputing_project

#the first thing you need to do is combine all the ref sequences for each gene into one file (per gene) so you can use muscle to align the sequences
cat ~/Private/Biocomputing2022/biocomputing_project_1/ref_sequences/mcrAgene_*.fasta > combined_McrA_ref_sequences.fasta
cat ~/Private/Biocomputing2022/biocomputing_project_1/ref_sequences/hsp70gene_*.fasta > combined_Hsp70_ref_sequences.fasta

#then align the sequences using muscle for both the reference McrA sequences and the reference Hsp70 sequences and store the aligned versions in files
~/Private/Biocomputing2022/tools/muscle -in combined_McrA_ref_sequences.fasta -out McrA_aligned.afa
~/Private/Biocomputing2022/tools/muscle -in combined_Hsp70_ref_sequences.fasta -out Hsp70_aligned.afa

#then you need to use the aligned files to generate/build  profiles to search for using hmmbuild
~/Private/Biocomputing2022/tools/hmmbuild --amino McrA_hmm_built_profile.fasta McrA_aligned.afa
~/Private/Biocomputing2022/tools/hmmbuild --amino Hsp70_hmm_built_profile.fasta Hsp70_aligned.afa


#after that, you need to search the proteomes for the McrA sequence.  If they do not have it, they can be discarded from consideration because the bacteria they are from are not methanogenic bacteria.
#So first we are going to copy the entire proteome folder so that we can just remove the non-methanogenic proteomes in the copy without permanently deleting them since we'll still have the original
cp -R ~/Private/Biocomputing2022/biocomputing_project_1/proteomes ~/Private/Biocomputing2022/biocomputing_project_1/methanogenic_proteomes
for file in ~/Private/Biocomputing2022/biocomputing_project_1/methanogenic_proteomes/*.fasta do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$file"_McrA_search.fasta McrA_hmm_built_profile.fasta $file
$num_hits=(grep -c -v "#" "$file_McrA_search.txt")
mv "$file"_McrA_search.fasta "Sfile"_McrA_search_with"$num_hits"hits.fasta
done
rm ~/Private/Biocomputing2022/biocomputing_project_1/methanogenic_proteomes/*_McrA_search_with0hits.fasta


#once you have discarded the non-methanogenic bacteria, you need to find those that can live in an acidic environment by looking for Hsp70 sequences in their proteomes.
#first you search for the Hsp70 sequence in all of the remaining proteomes using the Hsp70 profile you constructed earlier, using --tblout to get only the relevant data
#you can use grep to count the matches, then put each proteome name and the number of matches in a file
#then you need to sort the file full of proteomes to see which has the most good matches, which will be the one with the most Hsp70-type sequences and will be the most resistant to acid
for file in ~/Private/Biocomputing2022/biocomputing_project_1/methanogenic_proteomes/*.fasta do
~/Private/Biocomputing2022/tools/hmmsearch --tblout "$file"_search Hsp70_hmm_built_profile.fasta "$file"
$var=(cat "$file_search" | grep -c -v "#")
echo "$file" "$var" >> hsp_matches_per_proteome.txt
done

cat hsp_matches_per_proteome.txt | sort -t " " -k 2 -n > best_acid-resistant_methanogenic_bacteria.txt

cat ~/Private/Biocomputing2022/biocomputing_project_1/methanogenic_proteomes/*search.txt > Collated_Search_Results_for_Both_Genes.txt
#and then you're done
