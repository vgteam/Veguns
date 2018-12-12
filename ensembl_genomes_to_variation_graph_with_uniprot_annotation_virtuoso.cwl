class: Workflow
cwlVersion: v1.0

inputs:
  my_ncbiTaxid:
    type: string

steps:
  fetch_assembly_ids:
    run: retrieve_assembly_identifiers_for_proteomes_from_uniprot.cwl
    in:
      ncbiTaxid: my_ncbiTaxid
    out: [ assembly_identifiers ]

  fetch_ensembl_metadata:
    run: retrieve_metadata_from_ensembl_by_ncbi_taxid.cwl
    in:
      ncbiTaxid: my_ncbiTaxid
    out: [ ensemblgenomes_metadata ]

  filter_ensembl_metadata:
    run: turn_ensembl_metadata_into_four_column_csv_file.cwl
    in:
      ensemblgenomes_metadata: fetch_ensembl_metadata/ensemblgenomes_metadata
    out:
      [ensemblgenomes_metadata]

outputs: []
