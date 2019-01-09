## Ortholog pairs

*Scoring pairs of orthologs based on synteny to try find conserved regions*

### Usage

```
ortholog_pairs.pl species_1.gff species_2.gff orthologs.tsv | sort -nr -k17

#orthologs.tsv
species_1_gene	species_2_gene	score_1	score_2
```

### Example input from WormBase ParaSite - S. mansoni and E. multilocularis
S. mansoni and E. multilocularis GFFs: Downloaded from the species pages
Orthologs: retrieved from BioMart
  - start a new BioMart session
  - in query filters, select:
    + species - S. mansoni
    + restrict to genes with Orthologues - E. multilocularis
  - in query attributes, select:
    + Gene stable ID
    + Orthologues: E. multilocularis gene stable ID, % identity, E. multilocularis % identity
  - click "Results" and "save as TSV"
  - check the file is as expected and remove the header

### Reproduce example run
./ortholog_pairs.pl ./example/schistosoma_mansoni.PRJEA36577.WBPS12.annotations.gff3 ./example/echinococcus_multilocularis.PRJEB122.WBPS12.annotations.gff3 ./example/schistosoma_mansoni-echinococcus_multilocularis.orthologs.tsv | sort -nr -k17 > ./example/out/schistosoma_mansoni-echinococcus_multilocularis.ortholog_pairs.out.sorted

### Verifying results in WormBase ParaSite
We want to verify that the pairs of orthologs are near each other.
This is the top result:
```
Smp_080150	Smp_165330	EmuJ_000894600	EmuJ_000894700
```
We can proceed as follows:
- get the two E. multilocularis protein sequences from the BioMart
- BLAST them against S. mansoni
- go to gene pages of Smp_080150 or Smp_165330: "Region in detail" view
We can now see the two genes, and we can see the BLAST results - matches to E. multilocularis genes are also nearby. So everything checks out!

