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
      with open('$(inputs.filtered_ensemblgenomes_metadata.path)', 'r') as f:
          genomes = json.load(f)
          with open('/dev/stdout', 'wb') as fasta:
              for genome in genomes:
                  stepSize=50000
                  start=0;
                  for end in range(stepSize, int(genome['base_count']), stepSize):
                      bed="https://rest.ensemblgenomes.org/overlap/region/"+genome['species']+"/Chromosome:"+str(start)+":"+str(end)+"?feature=gene;content-type=text/x-bed"
                      start = start+stepSize
                      with urllib.request.urlopen(bed) as response:
                          data=response.read()
                          assembly_name=genome['assembly_name'].encode('utf-8')
                          base_count=genome['base_count'].encode('utf-8')
                          data=data.replace(b'chrChromosome',b''+assembly_name+b':'+assembly_name+b':Chromosome:1:'+base_count+b':1');
                          fasta.write(data)
outputs:
  concatenated_ensembl_bed:
    format: http://edamontology.org/format_3003
    type: File
    outputBinding:
      glob: ensembl.bed
stdout: ensembl.bed
