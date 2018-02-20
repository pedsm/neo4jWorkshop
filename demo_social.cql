CREATE INDEX ON :PERSON(id);
CREATE INDEX ON :COMPANY(id);

// Load (c:COMPANY)
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/pedsm/neo4jWorkshop/master/generatedData/companies.csv" AS row
WITH row 
MERGE (c:COMPANY {
    id: row.id,
    name: row.name,
    catchPhrase: row.catchPhrase
});

// Load (p:PERSON) and Companies
USING PERIODIC COMMIT 50000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/pedsm/neo4jWorkshop/master/generatedData/people.csv" AS person 
WITH person 
MATCH (c:COMPANY {id:person.company})
MERGE (p:PERSON {
    id: person.id,
    firstName: person.firstName,
    lastName: person.lastName,
    phone: person.phone,
    age: person.age
})-[:WORKS_AT]->(c);

USING PERIODIC COMMIT 50000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/pedsm/neo4jWorkshop/master/generatedData/friendships.csv" AS friendship 
WITH friendship 
MATCH (a:PERSON {id:friendship.aId})
MATCH (b:PERSON {id:friendship.bId})
MERGE (a)-[:FRIENDS_WITH]->(b);