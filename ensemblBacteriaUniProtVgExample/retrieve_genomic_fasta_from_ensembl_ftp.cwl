class: CommandLineTool
cwlVersion: v1.0
doc: Retrieve chromosomal fastas  id’s for the assemblys that are present in UniProtKB

hints:
  SoftwareRequirement:
    packages:
      python3: {}


baseCommand: python3
inputs:
  filtered_ensemblgenomes_metadata:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
      import json
      import urllib.request
      import gzip
      with open('$(inputs.filtered_ensemblgenomes_metadata.path)', 'r') as f:
        genomes = json.load(f)
        with open('/dev/stdout', 'wb') as fasta:
          for genome in genomes:
            collection=genome['dbname'].lower().split('_core')[0]
            loc="/pub/current/bacteria/fasta/"+collection+"/"+genome['species']+"/dna/"
            genomeFasta=genome['species'].capitalize()+'.'+genome['assembly_name']+'.dna.chromosome.Chromosome.fa.gz'
            with urllib.request.urlopen('ftp://ftp.ensemblgenomes.org'+loc+genomeFasta) as response:
              data=gzip.decompress(response.read())
              data=data.replace(b'>Chromosome dna:chromosome chromosome',b'>'+genome['assembly_name'].encode('utf-8'));
              fasta.write(data)

outputs:
  concatenated_ensembl_fasta:
    format: http://edamontology.org/format_1929
    type: File
    outputBinding:
      glob: ensembl.fasta
stdout: ensembl.fasta
