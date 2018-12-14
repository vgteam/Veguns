#!/usr/env/bin cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: Export a vg to turtle rdf
doc: This allows it being loaded into a triples store

hints:
  DockerRequirement:
    dockerPull: quay.io/vgteam/vg:dev-v1.12.1-51-g28ef4e32-t258-run
  SoftwareRequirement:
    packages:
      vg:
        version: ["1.12.1"]
        specs: [ https://doi.org/10.1038/nbt.4227 ]
#  ResourceRequirement:
#    coresMin: 1  # default!

inputs:
  vg:
    type: File
    # format: edam:format_1929  # we need a IRI/URI for FASTA format
  baseIRI:
    type: string
baseCommand: [ vg, view ]

arguments:
  - prefix: -r   #--rdf_base_uri
    valueFrom: $(inputs.baseIRI)
  - prefix: --vg-in
    valueFrom: $(inputs.vg.path)
  - prefix: --threads
    valueFrom: $(runtime.cores)
  - --turtle
outputs:
  genome_turtle:
    type: File
    outputBinding:
      glob: vg-$(inputs.vg.basename).ttl.gz
stdout: vg-$(inputs.vg.basename).ttl.gz

  # same as
  # genome_graph:
  #   type: File
  #   outputBinding:
  #     glob: $(inputs.reference_genome.nameroot)_$(inputs.genomic_varients.nameroot).vg

$namespaces:
  edam: http://edamontology.org/
