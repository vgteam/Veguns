class: Workflow
cwlVersion: v1.0

inputs:
  my_ncbiTaxid:
    type: string
  my_baseuri:
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

  fix_ensembl_turtle:
    run: fix_iris_in_turtle_from_ensembl.cwl
    in:
      ensembl_turtle: fetch_ensembl_ttl/concatenated_ensembl_turtle
    out:
      [ fixed_ensembl_turtle ]

  msga_the_fasta:
    run: fasta_vg_msga_into_graph.cwl
    in:
      fastas: fetch_fasta/concatenated_ensembl_fasta
    out:
      [ genome_graph ]

  xg_index_the_vg:
    run: xg_index_vg.cwl
    in:
      vg: msga_the_fasta/genome_graph
    out:
      [ genome_xg ]

  get_ensembl_bed:
    run: retrieve_bed_files_from_ensembl.cwl
    in:
      filtered_ensemblgenomes_metadata: filter_ensembl_metadata/filtered_ensemblgenomes_metadata
    out:
      [ concatenated_ensembl_bed ]

  annotate:
    run: annotate_a_vg_with_a_bed.cwl
    in:
      bed: get_ensembl_bed/concatenated_ensembl_bed
      xg: xg_index_the_vg/genome_xg
    out:
       [ gam ]
  mod:
    run: vg_mod_with_a_gam.cwl
    in:
      gam: annotate/gam
      vg: msga_the_fasta/genome_graph
    out:
      [ modded_vg ]

  vg_to_turtle:
    run: vg_to_turtle.cwl
    in:
      baseIRI: my_baseuri
      vg: mod/modded_vg
    out:
      [ genome_turtle ]

  fetch_uniprot:
    run: retrieve_rdf_from_uniprot.cwl
    in:
      filtered_ensemblgenomes_metadata: filter_ensembl_metadata/filtered_ensemblgenomes_metadata
    out:
      [ concatenated_uniprot_turtle ]

outputs:
  ensembl:
    type: File
    outputSource: fix_ensembl_turtle/fixed_ensembl_turtle
  uniprot:
    type: File
    outputSource: fetch_uniprot/concatenated_uniprot_turtle
  vg:
    type: File
    outputSource: vg_to_turtle/genome_turtle
