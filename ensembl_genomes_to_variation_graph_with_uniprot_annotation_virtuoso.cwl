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

  # filter_ensembl_metadata:
  #   run: turn_ensembl_metadata_into_four_column_csv_file.cwl
  #   in:
  #     ensemblgenomes_metadata: fetch_ensembl_metadata/ensemblgenomes_metadata
  #     ncbiTaxid: my_ncbiTaxid
  #   out:
  #     [ensemblgenomes_metadata]

  convertAssemblyIdsFromUniProtIntoRegex:
    run: convertAssemblyIdsFromUniProtIntoRegex.cwl
    in:
      assembly_identifiers: fetch_assembly_ids/assembly_identifiers
    out:
      [ assembly_identifiers_as_regex ]

  filter_ensembl_metadata:
    run: filter_ensembl_records_by_assembly_id.cwl
    in:
      ncbiTaxid: my_ncbiTaxid
      ensemblgenomes_metadata: fetch_ensembl_metadata/ensemblgenomes_metadata
      assembly_identifiers_as_regex: convertAssemblyIdsFromUniProtIntoRegex/assembly_identifiers_as_regex
    out:
      [ filtered_ensemblgenomes_metadata ]

  fetch_fasta:
    run: retrieve_genomic_fasta_from_ensembl_ftp.cwl
    in:
      filtered_ensemblgenomes_metadata: filter_ensembl_metadata/filtered_ensemblgenomes_metadata
    out:
      [ concatenated_ensembl_fasta ]

  fetch_ensembl_ttl:
    run: retrieve_turtle_from_ensembl.cwl
    in:
      filtered_ensemblgenomes_metadata: filter_ensembl_metadata/filtered_ensemblgenomes_metadata
    out:
      [ concatenated_ensembl_turtle ]
outputs: []
