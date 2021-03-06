
##### Ace resistant mutations origin #####

###Author:Sonja_Lecic_07_2019

### Haplotype pipeline for Portugal, South Africa and Florida haplotypes ####


#### clean bam files ####
for f in $(ls $bam_files)
do
         X=$(basename $f .bam)
         picard CleanSam I=$f O=/Users/slecic/Documents/Portugal_Ace_freebayes/bam_files/"$X".clean
done


#### sort ####
for f in $(ls $bam_files)
do
        X=$(basename $f .clean)
        samtools sort $f -o /Users/slecic/Documents/Portugal_Ace_freebayes/bam_files/"$X".sort --threads 8
done


### remove duplicates ####
for f in $(ls $bam_files)
do
         X=$(basename $f .bam)
         picard CleanSam I=$f O=/Users/slecic/Documents/Portugal_Ace_freebayes/bam_files/"$X".clean
done

### filter for quality > 20 ###
for f in $(ls $bam_files)
do
        X=$(basename $f .remdup)
        samtools view -q 20 -f 0x0002 -F 0x0004 -F 0x0008 -b $f > /Users/slecic/Documents/Portugal_Ace_freebayes/bam_files/"$X".fq20
done


### add read groups ##
for f in $(ls $fq20)
do
        X=$(basename $f .rg)
        picard AddOrReplaceReadGroups I="$X" O="$X".rg RGID="$X" RGLB="$X" RGPL="$X" RGPU="$X" RGSM="$X"
done


### extract 3R chromosome ###
for f in $(ls $haplotype_origin_ace)
do
        X=$(basename $f .fq20)
        samtools view -b $f "3R" > /Volumes/LaCie/haplotype_origin_ace/"$X".3R
done


## call SNPs on a population #
freebayes -f /Users/slecic/Documents/Portugal_Ace_freebayes/dsimM252.1.1.clean.wMel_wRi_Lactobacillus_Acetobacter.fa -F 0.02 -C 2 -m 20 -q 20 *aceRegion_rg.bam | vcffilter -f "QUAL > 20" > Portres3mut.vcf


## estimate nucleotide diversity with vcftools ##

vcftools --vcf Portres3mut.vcf --window-pi 7000 --out Portres3mutpi














