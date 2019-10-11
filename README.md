# TE_expression

These files relate to the following article. 
Anderson SN, Stitzer MC, Zhou P, Ross-Ibarra J, Hirsch CD, and Springer NM 2019. Dynamic patterns of transcript abundance of transposable element families in maize. G3. https://doi.org/10.1534/g3.119.400431 

RNA-seq libraries were processed by trimming with cutadapt v.1.8.1 (-m 30 -q 10 --quality-base=33) following by mapping to the B73v4 genome assembly (Jiao et al. 2017) with tophat2 v.2.0.13 (-g 20 -i 5 -I 60000) (Kim et al. 2013), allowing for up to 20 mapping positions. BAM output files were then sorted, converted to SAM format, and reformatted for compatibility with HTSeq (Anders et al. 2015) using the convert_sam_to_all_NH1_v2.pl script. Using HTseq v.0.5.3, reads were intersected with a modified annotation file B73.structuralTEv2.1.07.2019.filteredTE.subtractexon.plusgenes.chr.sort.gff3. This annotation file was created by first masking exons from the disjoined TE annotation file B73.structuralTEv2.2018.12.20.filteredTE.disjoined.gff3 found at https://github.com/SNAnderson/maizeTE_variation, appending full gene model annotations, and reformatting to remove features on contigs and to format for use in HTseq. TE and gene expression was counted from the SAM output of HTseq using script te_family_mapping_ver6.pl. 

Briefly, reads were assigned to genes when they map uniquely and hit a gene annotation but not any TE annotation. Reads were assigned to a TE element when they map uniquely and hit a single TE annotation (with an overlap of at least 1 bp), and reads were assigned to a TE family when they map uniquely or multiple times but only hit a single TE annotation. Ambiguous reads were defined by hits assigned to both a gene and a TE and were counted to columns labeled te.g for the TE element or family. Two output files were created for each library. The first file contains TE family counts for 4 categories of reads: unique reads hitting one TE family (u_te.fam; Read E in Figure 1), unique ambiguous reads (u_te.g; Read B in Figure 1), multi reads to one family (m_te.fam; Read D in Figure 1), and multi ambiguous reads (m_te.g; Read C in Figure 1). The second file contains unique counts only to both genes and TEs and contains two columns: unique reads hitting a single TE or gene (unique; Reads A and E in Figure 1) and unique reads hitting both a TE and a gene (te.g; Read B in Figure 1). In addition, a single line for each library with the total number of reads assigned to each category is added to a file called te_mapping_summary.txt. 

Count tables for each library were then combined using the script combine_count_totals.pl. Four output tables were created. The first file (multi_combined_counts.txt) includes all four count columns per library for each TE family and the second file (element_combined_counts.txt) includes two count columns per library for each TE element and gene. The third file (family_sum_combined_counts.txt) contains counts for TE families in a single column per library, corresponding to the sum of u_te.fam and m_te.fam columns. Finally, the fourth file (family_prop_unique.txt) contains a single column per library with the proportion of the reads in file three that are derived from unique-mapping reads. 

See sample_shell_script.sh for workflow example. 

UPDATE 11 October 2019: An updated version of the file te_family_mapping_ver6.pl is not available and uploaded as te_family_mapping_ver6.1.pl. This update fixes a bug where, in paired-end reads, one mate could be multi-mapping and the other could be unique mapping to a single element and the script would assign this read as unique to one element but assign the family as "Multifam". Now, these cases are counted as unique mapping to the element and assigned to the correct family. 
