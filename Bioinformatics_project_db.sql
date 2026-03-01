# TABLE1 SPECIES 
CREATE TABLE Species(
    species_id INT PRIMARY KEY,
    species_name VARCHAR(100),
    family VARCHAR(100),
    crop_type VARCHAR(50)
);

# TABLE2 GENE
CREATE TABLE Gene(
    gene_id INT PRIMARY KEY, 
    gene_name VARCHAR(100),
    gene_family VARCHAR(50),
    chromosome VARCHAR(20),
    species_id INT,
    FOREIGN KEY (species_id) REFERENCES Species(species_id)   
);

#Table3 SEQUENCE
CREATE TABLE Sequence(
    sequence_id INT PRIMARY KEY,
    gene_id INT, 
    sequence_type VARCHAR(20), 
    LENGTH INT,
    gc_content Decimal (5,2)
    FOREIGN KEY (gene_id) REFERENCES Gene(gene_id)
);

#Table4 DOMAIN
CREATE TABLE Domain (
    domain_id INT PRIMARY KEY, 
    gene_id INT,
    domain_name VARCHAR(100),
    start_position INT, 
    end_position INT,
    FOREIGN KEY(gene_id) REFERENCES Gene(gene_id)
);

#Table5 EXPRESSION 
CREATE TABLE Expression(
    expression_id INT PRIMARY KEY,
    gene_id INT,
    tissue VARCHAR(50),
    condition_type VARCHAR(50),
    expression_level DECIMAL(6,2),
    FOREIGN KEY (gene_id REFERENCES Gene(gene_id))
);

INSERT INTO Species VALUES
(1, 'Cicer arietinum' 'Fabaceae' ,'Pulse'),
(2, 'Oryza sativa', 'Poaceae', 'Cereal'),
(3, 'Triticum aestivum', 'Poaceae', 'Cereal'),
(4, 'Zea mays', 'Poaceae', 'Cereal'),
(5, 'Camelina sativa' 'Brassicaceae', 'oilseed');

INSERT INTO Gene VALUES
(101, 'CaPHT1', 'PHT1', 'Chr2', 1),
(102, 'OsPHT1', 'PHT1', 'Chr3', 2), 
(103, 'TaPHT1', 'PHT1', 'Chr5', 3),
(104, 'ZmPHT1', 'PHT1', 'Chr1', 4),
(105, 'CsPHT1', 'PHT1', 'Chr8', 5);

INSERT INTO Sequence VALUES
(201, 101, 'DNA', 1650, 42.35),
(202, 102, 'DNA', 1725, 48.10),
(203, 103, 'DNA', 1680, 46.80),
(204, 104, 'DNA', 1702, 47.25),
(205, 105, 'DNA', 1605, 41.95);

INSERT INTO Domain VALUES
(301, 101, 'Major Facilitator Superfamily', 50, 450),
(302, 102, 'Major Facilitator Superfamily', 60, 460),
(303, 103, 'Major Facilitator Superfamily', 55, 440),
(304, 104, 'Major Facilitator Superfamily', 52, 455),
(305, 105, 'Major Facilitator Superfamily', 48, 430);

INSERT INTO Expression VALUES
(401, 101, 'Root', 'Phosphorus Deficiency', 8.75),
(402, 102, 'Root', 'Phosphorus Deficiency', 9.20),
(403, 103, 'Leaf', 'Control', 4.30),
(404, 104, 'Root', 'Phosphorus Deficiency', 7.95),
(405, 105, 'Leaf', 'Control', 3.85);

# LIST ALL PHT1 gene in Cereals 
SELECT g.gene_name, s.species_name
FROM Gene g 
JOIN Species s ON g.species_id = s.species_id
WHERE s.crop_type= 'Cereal';

# AVERAGE GC CONTENT BY CROP TYPE 
SELECT s.crop_type, AVG(seq,gc_content) AS avg_gc
FROM Sequence seq 
JOIN Gene g ON seq.gene_id = g.gene_id 
JOIN Species s ON g.species_id= s.species_id 
GROUP BY s.crop_type;

# Genes highly expressed in Phosphorus deficiency 
SELECT g.gene_name, e.expression_level
FROM Expression e 
JOIN Gene g ON e.gene_id = g.gene_id
WHERE e.condition_type = 'Phosphorus Deficiency'
ORDER BY e.expression_level DESC;

# Longest PHT1 gene 
SELECT g.gene_name, seq.length
From Sequence seq
JOIN Gene g ON seq.gene_id = g.gene_id
ORDER BY seq.length DESC 
LIMIT 1 

# Species with highest GC content 
SELECT s.species_name, MAX(seq.gc_content)
FROM Sequence seq 
JOIN Gene g ON seq.gene_id = g.gene_id 
JOIN Species s ON g.species_id = s.species_id 
GROUP BY s.species_name
ORDER BY MAX(seq.gc_content) DESC;


