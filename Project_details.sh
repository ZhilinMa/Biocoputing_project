#Generate a shell script to do the following

#Identify methanogens (McrA+)/proteome
	#18 mcrA genes
	#compile genes - return file "mcr.refs"
for mcr_file in (file_path)
do
cat $mcr_file >> mcr.refs
	#use muscle to generate a HMM of aligned mcrA genes

	#hmmerbuild to build HMM profile
	#hmmersearch to use HMM profile to search proteomes
		#interpret results (E-value, bit score)
		#E-value - #hits expected by chance, decreases as alignment score increases (want low)
			#shorter sequences have higher probability of high E-values due to chance
		#bit score - #required size of database in which current match found by chance
			#-log2 scale - each increase doubles required database size (want this high)
	#sort by (x)
	#remove proteomes that fail to match
	#echo proteome filenames > methanogens.txt

#pH resistance identified: proxy is how many Hsp70 genes present/proteome
	#22 hsp70 gene files
for hsp_file in (path)
do
cat $hsp_file >> hsp70.refs
done

	#use muscle to generate a HMM of aligned Hsp70 genes
	#hmmerbuild to build HMM profile
	#hmmersearch to use HMM profile to search proteomes
		#interpret results

#Produce summary table collating results of script

#Provide text file with the names of candidate pH-resistant methanogens

