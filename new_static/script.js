function clearDisplay(tab) {
    document.getElementById(`display${tab}`).value = '';
}

function appendInput(value, tab) {
    document.getElementById(`display${tab}`).value += value;
}

function backspaceInput(tab) {
    let display = document.getElementById(`display${tab}`);
    let currentValue = display.value;
    display.value = currentValue.slice(0, -1); // Remove the last character
}

function calculate(tab) {
    let expression = document.getElementById(`display${tab}`).value;
    try {
        let result = eval(expression);
        document.getElementById(`display${tab}`).value = result;
    } catch (error) {
        document.getElementById(`display${tab}`).value = 'Error';
    }
}

function calculateCompoundInterest() {
    let principal = parseFloat(document.getElementById('principal').value);
    let rate = parseFloat(document.getElementById('rate').value) / 100;
    let time = parseFloat(document.getElementById('time').value);

    let amount = principal * Math.pow((1 + rate), time);
    let interest = amount - principal;

    document.getElementById('compoundInterestResult').innerHTML = `Compound Interest: ${interest.toFixed(2)} <br> Total Amount: ${amount.toFixed(2)}`;
}

function openTab(evt, tabName) {
    var i, tab, tablinks;
    tab = document.getElementsByClassName("tab-pane");
    for (i = 0; i < tab.length; i++) {
        tab[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("nav-link");
    for (i = 0; i < tablinks.length; i++) {
        // tablinks[i].className = tablinks[i].className.replace(" active", "");
        tablinks[i].classList.remove("active")
    }
    document.getElementById(tabName).style.display = "";
    // evt.currentTarget.className += " active";
    evt.currentTarget.classList.add("active")
}
