#Zhilin - these file paths are relative to our respective file structures. Mine is not the same as Joe's
#Here are the assumptions we are making:
#You are within the root directory in the CRC
#You are using exclusively absolute paths for all files
	#We understand that for orthogonality sake, this is not ideal, but we are still able to get our results this way
	#If you see "file_path" that is in reference to our respective file path to get to the location of our project files
		#Individual paths will be written here and commented out, use whatever is in reference to your file structure

#Goal 1: Generate reference files for mcrA and hsp70 genes using muscle:
#18 mcrA genes, 22 hsp70 genes

	for mcr_file in (file_path1)/mcr*.fasta
	do
	cat $mcr_file >> mcr.refs
	done

	for hsp_file in (file_path1)/hsp*.fasta
	do
	cat $hsp_file >> hsp.refs
	done

		#(file_path1)
			#Chris's: ~/Private/Biocomputing_Project/ref_sequences
			#Joe's:

#Goal 2: Use MUSCLE to generate a HMM of aligned mcrA and hsp70 genes
	(file_path2)/muscle -in ~/mcr.refs -out mcr_align
	(file_path2)/muscle -in ~/hsp.refs -out hsp_align
		
		#(file_path2)
		#Chris's: ~/Private/Biocomputing2022/tools
		#Joe's:

#Goal 3: Use hmmbuild to build an HMM profile for each gene type
	(file_path2)/hmmbuild mcrhmm mcr_align
	(file_path2)/hmmbuild hsphmm hsp_align

#Goal 4: Use hmmsearch in a for loop to identify if genes are present, and if so how frequently; produce summary table

echo "proteome_name", "mcr_count", "hsp_count" > summary_table.csv
for proteome in (file_path3)/proteome_*.fasta
do
(file_path2)/hmmsearch --tblout mcr_table mcrhmm $proteome
(file_path2)/hmmsearch --tblout hsp_table hsphmm $proteome
proteome_name=$(echo "$proteome")
mcr_count=$(cat mcr_table|grep -o "WP_*"|wc -l)
hsp_count=$(cat hsp_table|grep -o "WP_*"|wc -l)
echo "$proteome_name", "$mcr_count", "$hsp_count">>summary_table.csv
done

		#(file_path3)
		#Chris's: ~/Private/Biocomputing_Project/proteomes
		#Joe's:


#Goal 5: Sort by presence of mcrA (column 2), presence of hsp70 (column 3)
	#mcrA >1, produces methane
	#number of hsp70 increases, increased pH resistance
#Provide text file with the names of candidate pH-resistant methanogens (i.e. head, to a certain point)


