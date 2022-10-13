#Generate a shell script to do the following

#Identify methanogens (McrA+)/proteome
	#18 mcrA genes
	#compile genes - return file "mcr.refs"
for mcr_file in (file_path)
do
cat $mcr_file >> mcr.refs
	#use muscle to generate a HMM of aligned mcrA genes
~/Private/Biocomputing/tools/muscle -in ~/mcr.refs -out mcr_align

	#hmmerbuild to build HMM profile
~/Private/Biocomputing/tools/hmmbuild mcrhmm mcralign

	#hmmersearch to use HMM profile to search proteomes
		#interpret results (E-value, bit score)
		#E-value - #hits expected by chance, decreases as alignment score increases (want low)
			#shorter sequences have higher probability of high E-values due to chance
		#bit score - #required size of database in which current match found by chance
			#-log2 scale - each increase doubles required database size (want this high)
	#sort by (x)
	#remove proteomes that fail to match
	#echo proteome filenames > methanogens.txt

#pH resistance identified: proxy is how many Hsp70 genes present
	#22 hsp70 gene files
for hsp_file in (path)
do
cat $hsp_file >> hsp70.refs
done

	#use muscle to generate a HMM of aligned Hsp70 genes
~/Private/Biocomputing2022/tools/muscle - in ~/hsp.refs
	#hmmerbuild to build HMM profile
~/Private/Biocomputing/tools/hmmbuild hsphmm hspalign

	#hmmersearch to use HMM profile to search proteomes
For proteome in ~/Private/Biocomputing2022/Biocomputing_Project/proteomes/proteome_*.fasta
Do
~Private/Biocomputing/tools/hmmsearch --tblout hsp_table hsphmm $proteome
		#interpret results

#Produce summary table collating results of script

#Provide text file with the names of candidate pH-resistant methanogens

#Joe - I would not run this script right away bc your file system and mine 
#are likely different; this includes the hmmtools steps and a potential try at the hmmersearch
#I cannot connect to VPN right now, this is my best try. I will text when I get to my airBNB and if you can't get hmmsearch to work, lmk.

