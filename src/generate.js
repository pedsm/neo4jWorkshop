const faker = require('faker')
const json2csv = require('json-2-csv').json2csv
const fs = require('fs')
let personId = 0
let companyId = 0

// Generates a person
function createPerson(companiesMax, pplMax) {
    return {
        id: personId++,
        firstName: faker.name.firstName(),
        lastName: faker.name.lastName(),
        phone: faker.phone.phoneNumberFormat(),
        age: (faker.random.number() % 40) + 18,
        company: (faker.random.number() % companiesMax),
    }
}

// Generates a friends list
function createFriendsList(index, pplMax) {
    const maxFriends = (faker.random.number() % 40) + 10
    const ids = new Set()
    for (let i = 0; i < maxFriends; i++) {
        ids.add({
            aId: index,
            bId: faker.random.number() % pplMax
        })
    }
    return [...ids]
}

// Generates a company
function createCompany() {
    return {
        id: companyId++,
        name: faker.company.companyName(),
        catchPhrase: faker.company.catchPhrase(),
    }
}

// makes the whole dataset
function generateEverything() {
    const maxPpl = 30000
    const maxCompanies = 1000
    const returnable = {
        people: [],
        companies: [],
        friendships: []
    }
    for(let i = 0; i < maxPpl; i++) {
        returnable.people.push(createPerson(maxCompanies, maxPpl))
        returnable.friendships.push(...createFriendsList(i, maxPpl))
    }
    for(let i = 0; i < maxCompanies; i++) {
        returnable.companies.push(createCompany())
    }
    return returnable
}

const fileData = generateEverything()
console.log(`File written:
People:${fileData.people.length}
Companies:${fileData.companies.length}
Friendships:${fileData.friendships.length}
    `)

function saveFile(path, data) {
    json2csv(data, ((err, csv) => {
        fs.writeFile(`import/${path}`, csv, (err) => {
            if (err) {
                throw err
            }
            console.log(`File ${path} written`)
        })
    }), {
        delimiter: {
            wrap: '"'
        }
    })
}
saveFile('people.csv', fileData.people)
saveFile('companies.csv', fileData.companies)
saveFile('friendships.csv', fileData.friendships)
