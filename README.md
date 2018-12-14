# Veguns

This is a repository of VG related CWL workflows

# VG, EnsemblBacteria and UniProt

This a CWL workflow to turn bacterial genomes from ensembl into a VG pangenome variation graph. And connects it to the protein world of UniProt :)


![workflow](https://view.commonwl.org/graph/png/github.com/vgteam/Veguns/blob/master/ensemblBacteriaUniProtVgExample/ensembl_genomes_to_variation_graph_with_uniprot_annotation_rdf.cwl)
## Running

```
 cwltool ensemblBacteriaUniProtVgExample/ensembl_genomes_to_variation_graph_with_uniprot_annotation_rdf.cwl --my_ncbiTaxid 83333 --my_baseuri http://example.org/vg83333/
```

