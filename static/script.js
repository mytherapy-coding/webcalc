// Function to clear display in a specified tab
function clearDisplay(tab) {
    document.getElementById(`display${tab}`).value = '';
}

// Function to append input to display in a specified tab
function appendInput(value, tab) {
    document.getElementById(`display${tab}`).value += value;
}

// Function to remove the last character from display in a specified tab
function backspaceInput(tab) {
    let display = document.getElementById(`display${tab}`);
    let currentValue = display.value;
    display.value = currentValue.slice(0, -1); // Remove the last character
}

// Function to evaluate and display result in a specified tab
function calculate(tab) {
    let expression = document.getElementById(`display${tab}`).value;
    try {
        let result = eval(expression);
        document.getElementById(`display${tab}`).value = result;
    } catch (error) {
        document.getElementById(`display${tab}`).value = 'Error';
    }
}

// Function to share expression based on the active tab
async function shareExpression(tab) {
    url = 'http://localhost:10000/api/save'
    if (tab === 1) {
        let expression = document.getElementById(`display${tab}`).value;

        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ "content": expression })
            });

            const data = await response.json();
            const shortUrl = `http://localhost:10000/api/${data.short_url}`;
            document.getElementById('shareResult1').textContent = `Short URL: ${shortUrl}`;
        } catch (error) {
            console.error('Failed to share expression:', error);
            document.getElementById('shareResult1').textContent = 'Failed to share expression. Please try again.';
        }
    } else if (tab === 2) {
        let principal = parseFloat(document.getElementById('principal').value);
        let rate = parseFloat(document.getElementById('rate').value);
        let time = parseFloat(document.getElementById('time').value);

        if (isNaN(principal) || isNaN(rate) || isNaN(time)) {
            document.getElementById('compoundInterestResult').textContent = 'Invalid input. Please enter numeric values.';
            return;
        }

        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ "content": `Principal: ${principal}, Rate: ${rate}, Time: ${time}` })
            });

            const data = await response.json();
            const shortUrl = `http://localhost:10000/api/${data.short_url}`;
            document.getElementById('shareResult2').textContent = `Short URL: ${shortUrl}`;
        } catch (error) {
            console.error('Failed to share expression:', error);
            document.getElementById('shareResult2').textContent = 'Failed to share expression. Please try again.';
        }
    }
}


// Function to calculate compound interest and display result
function calculateCompoundInterest() {
    let principal = parseFloat(document.getElementById('principal').value);
    let rate = parseFloat(document.getElementById('rate').value) / 100;
    let time = parseFloat(document.getElementById('time').value);

    let amount = principal * Math.pow((1 + rate), time);
    let interest = amount - principal;

    document.getElementById('compoundInterestResult').innerHTML = `Compound Interest: ${interest.toFixed(2)} <br> Total Amount: ${amount.toFixed(2)}`;
}

// Function to switch between tabs and update active state
function openTab(evt, tabName) {
    var i, tab, tablinks;
    tab = document.getElementsByClassName("tab-pane");
    for (i = 0; i < tab.length; i++) {
        tab[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("nav-link");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].classList.remove("active")
    }
    document.getElementById(tabName).style.display = "";
    evt.currentTarget.classList.add("active")
}


