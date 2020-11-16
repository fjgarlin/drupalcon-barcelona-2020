#!/bin/bash

# Build site.
rm -rf blank-site
mkdir blank-site
cd blank-site
echo "<a href='about.html'>About</a>" > index.html
echo "About" > about.html

# Launch server.
nohup php -S localhost:2020 > phpd.log 2>&1 &
PHP_SERVER_PID=$!

# Install CypressIO and create first test.
echo "{}" > package.json
npm install cypress --save-dev
test="
describe('About page', () => {
    it('Goes to about page', () => {
        cy.visit('http://localhost:2020')
        //cy.visit('https://events.drupal.org/europe2020')
        cy.contains('About').click()
        cy.url().should('include', '/about')
    })
})
"
mkdir cypress && mkdir cypress/integration
touch cypress/integration/first_test.js
echo "$test" > cypress/integration/first_test.js

npx cypress open

# Quit server and remove folder.
kill -9 $PHP_SERVER_PID