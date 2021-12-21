function hidden_block() {
    document.getElementById('block_main').style.display = 'none';
    document.getElementById('block_registration').classList.remove("hidden");
}

function hidden_block2() {
    document.getElementById('block_main').style.display = 'none';
    document.getElementById('create_room').classList.remove("hidden");
}

function password_notification() {
    document.getElementById('heading_pas').innerText = "Письмо для восстановления пароля отправлено вам на почту";
}

function password_block() {
    document.getElementById('block_registration').style.display = 'none';
    document.getElementById('block_password').classList.remove("hidden");
    document.getElementById('block_password').style.display = 'block';
}

function hidden_block3() {
    document.getElementById('block_password').style.display = 'none';
    document.getElementById('block_registration').style.display = 'block';
}

document.forms.authForm.onsubmit = function (e){
    e.preventDefault();

    var company = document.forms.authForm.company.value;
    var email = document.forms.authForm.email.value;
    var password = document.forms.authForm.password.value;
    var token = document.forms.authForm.authenticity_token.value;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/authorization");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'company=' + encodeURIComponent(company) +
        '&email=' + encodeURIComponent(email) +
        '&password=' + encodeURIComponent(password) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            if (xhr.responseText == 'true')
            {
                location.replace("http://localhost:3000/");
            }
            document.getElementById('error').innerText = xhr.responseText;
            document.getElementById('error').style.padding = "5px";
            document.getElementById('block_registration').style.height = "400px";
            document.getElementById('block_registration').style.maxHeight = "400px";
        }
    }
    xhr.send(body)
};

document.forms.passForm.onsubmit = function (e){
    e.preventDefault();

    var company = document.forms.passForm.company.value;
    var email = document.forms.passForm.email.value;
    var token = document.forms.passForm.authenticity_token.value

    var xhr = new XMLHttpRequest();

    var params = 'company=' + encodeURIComponent(company) +
        '&email=' + encodeURIComponent(email) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.open("GET", "/send_password?" + params)

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('pass_error').innerText = xhr.responseText;
            document.getElementById('pass_error').style.padding = "5px";
            document.getElementById('block_password').style.height = "360px";
            document.getElementById('block_password').style.maxHeight = "360px";
        }
    }
    xhr.send()
};

document.forms.regForm.onsubmit = function (e){
    e.preventDefault();

    var company = document.forms.regForm.company.value;
    var email = document.forms.regForm.email.value;
    var name = document.forms.regForm.name.value;
    var surname = document.forms.regForm.surname.value;
    var password = document.forms.regForm.password.value;
    var password_confirmation = document.forms.regForm.password_confirmation.value;
    var token = document.forms.regForm.authenticity_token.value

    if (password != password_confirmation)
    {
        document.getElementById('reg_error').innerText = "Введенные пароли не совпадают"
        document.getElementById('create_room').style.height = "530px";
        document.getElementById('create_room').style.maxHeight = "530px";
        return
    }

    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/create_room")
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'company=' + encodeURIComponent(company) +
        '&email=' + encodeURIComponent(email) +
        '&name=' + encodeURIComponent(name) +
        '&surname=' + encodeURIComponent(surname) +
        '&password_confirmation=' + encodeURIComponent(password_confirmation) +
        '&password=' + encodeURIComponent(password) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('reg_error').innerText = xhr.responseText;
            document.getElementById('create_room').style.height = "590px";
            document.getElementById('create_room').style.maxHeight = "590px";
        }
    }
    xhr.send(body)
};

function show_hide_password(target){
    var input = document.getElementById('password-input');
    if (input.getAttribute('type') == 'password') {
        target.classList.add('view');
        input.setAttribute('type', 'text');
    } else {
        target.classList.remove('view');
        input.setAttribute('type', 'password');
    }
    return false;
}
