rm mcrAgene_ref.fasta hsp70_ref.fasta mcrA_aligned.fasta hsp70_aligned.fasta mcrA.hmm hsp70.hmm table.txt

# add all mcrA references to one file
for file in $(ls ref_sequences/ | grep -E 'mcr') 
do
	cat ref_sequences/$file >> mcrAgene_ref.fasta 
done

# add all HSP references to one file
for file in $(ls ref_sequences/ | grep -E 'hsp') 
do
	cat ref_sequences/$file >> hsp70_ref.fasta 
done

# align the mcrA reference file using muscle
../tools/muscle -in mcrAgene_ref.fasta -out mcrA_aligned.fasta

# align the HSP reference file using muscle
../tools/muscle -in hsp70_ref.fasta -out hsp70_aligned.fasta

# use hmmbuild on mcrA aligned file
../tools/hmmbuild mcrA.hmm mcrA_aligned.fasta

# use hmmbuild on HSP aligned file
../tools/hmmbuild hsp70.hmm hsp70_aligned.fasta

# table header
echo -e "proteome #\t\t\t\t\tmcrA\t\t\t\t\thsp70" >> table.txt

# loop through each proteome
i=1
for proteome in $(ls proteomes/ | grep -E 'proteome')
do
	# call hmmsearch to see how many mcrA in curr_proteome
	../tools/hmmsearch --tblout curr_mcr.out mcrA.hmm proteomes/$proteome 
	curr_mcr_count=$(cat curr_mcr.out | grep -v '#' | wc -l)
	# call hmmsearch to see how many HSP in curr_proteome 
	../tools/hmmsearch --tblout curr_hsp.out hsp70.hmm proteomes/$proteome 
	curr_hsp_count=$(cat curr_hsp.out | grep -v '#' | wc -l)

	# echo results 
	echo -e "proteome $i\t\t\t\t\t $curr_mcr_count\t\t\t\t\t\t  $curr_hsp_count" >> table.txt

	# make recommendations
	if [ $curr_mcr_count -gt 0 -a $curr_hsp_count -gt 1 ]; then
			echo "proteome $i" >> recommendations.txt
	fi
	i=$((i+1))
done

# go through table to make recommendations
