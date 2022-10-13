#Usage: run this code inside the biocomputing_project directory in a CRC FE machine with the default setup we were told to use (after changing the name of the cloned directory to biocomputing_project_1
#so it is spelled right and has no spaces or capitalization to deal with)
#So muscle, hmmrbuild, and hmmrsearch should be in ~/Private/Biocomputing2022/tools, and the biocomputing_project directory is in ~/Private/Biocomputing2022/biocomputing_project
#the first thing you need to do is align the sequences using muscle for both the reference McrA sequences and the reference Hsp70 sequences and store the aligned versions in files



#then you need to use the aligned files to generate/build  profiles to search for using hmmbuild



#after that, you need to search the proteomes for the McrA sequence.  If they do not have it, they can be discarded from consideration because the bacteria they are from are not methanogenic bacteria.
#So first we are going to copy the entire proteome folder so that we can just remove the non-methanogenic proteomes in the copy without permanently deleting them since we'll still have the original



#once you have discarded the non-methanogenic bacteria, you need to find those that can live in an acidic environment by looking for Hsp70 sequences in their proteomes.
#first you search for the Hsp70 sequence in all of the remaining proteomes using the Hsp70 profile you constructed earlier
#then you need to isolate the whole sequence matches
#then you need to sort the proteomes to see which has the most good matches, which will be the one with the most Hsp70-type sequences and will be the most resistant to acid
~/Private/Biocomputing2022/tools/hmmsearch --noali  hmm_built_hsp.fasta proteome_*.fasta | grep -A 10 "Scores for complete sequences (score includes all domains):"

