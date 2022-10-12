rm mcrAgene_ref.fasta hsp70_ref.fasta mcrA_aligned.fasta hsp70_aligned.fasta mcrA.hmm hsp70.hmm

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

# loop through each proteome
for proteome in $(ls proteomes/ | grep -E 'proteome')
do
	# call hmmsearch to see how many mcrA in curr_proteome
	../tools/hmmsearch mcrA.hmm proteomes/$proteome >> curr.out

	# call hmmsearch to see how many HSP in curr_proteome 
	../tools/hmmsearch hsp70.hmm proteomes/$proteome >> curr.out

	# echo results 
done

# go through table to maj=ke recommendations
