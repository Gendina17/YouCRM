function show(name) {
    document.getElementById(name).classList.toggle("hidden");
}

function add_email(){
    var email = document.forms.emailForm.email.value;
    var password = document.forms.emailForm.password.value;
    var send = !!document.forms.emailForm.send.checked
    var token = document.forms.emailForm.authenticity_token.value;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/add_email.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'email=' + encodeURIComponent(email) +
        '&password=' + encodeURIComponent(password) +
        '&send=' + encodeURIComponent(send) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById("alert").innerHTML = xhr.responseText;
        }
    }
    xhr.send(body)
}

function set_focus(el) {
    for(i=1; i<6; i++){
        document.getElementById(`but_${i}`).classList.remove("i_active");
    }
    el.classList.add("i_active");
}

function alert_about_photo(input){
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function(e) {
            document.getElementById('img').src = e.target.result;
        }
        reader.readAsDataURL(input.files[0]);
    }
}

function show_form(n) {
    let form = new Array();
    form = ["clientForm", "clientCompanyForm"]
    if (n ==0){
        document.getElementById(form[0]).classList.remove("hidden");
        document.getElementById(form[1]).classList.add("hidden");
        document.getElementById('menu23').classList.remove("add_to_but");
        document.getElementById('menu13').classList.add("add_to_but");
    } else {
        document.getElementById(form[1]).classList.remove("hidden");
        document.getElementById(form[0]).classList.add("hidden");
        document.getElementById('menu13').classList.remove("add_to_but");
        document.getElementById('menu23').classList.add("add_to_but");
    }

}

function show_block(n) {
    let form = new Array();
    form = ["service_fields", "fields_product"]
    if (n ==0){
        document.getElementById(form[0]).classList.remove("hidden");
        document.getElementById(form[1]).classList.add("hidden");
    } else {
        document.getElementById(form[1]).classList.remove("hidden");
        document.getElementById(form[0]).classList.add("hidden");
    }

}

function set_clients_fields(name, class_name){
    form = document.getElementById(name);
    var type_client = form.type_client.value;
    var token = form.authenticity_token.value

    r = document.getElementsByClassName(class_name);

    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/set_clients_fields.json")
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'type_client=' + encodeURIComponent(type_client) +
        '&authenticity_token=' + encodeURIComponent(token);

    for (i = 0; i<r.length/2; i++){
        if (r[i].checked){
            body += `&fields[${i}]=` + encodeURIComponent(r[i].value)
        }
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('client_alert').innerText = xhr.responseText;
        }
    }
    xhr.send(body)
    return false
}

function set_type_product(){
    var type_product = document.forms.productForm.type_product.value;
    var token = document.forms.productForm.authenticity_token.value;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/set_type_product.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'type_product=' + encodeURIComponent(type_product) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById("alert_product").innerHTML = xhr.responseText;
        }
    }
    xhr.send(body)
}

function create_status() {
    var title = document.forms.statusForm.title.value;
    var description = document.forms.statusForm.description.value;
    var token = document.forms.statusForm.authenticity_token.value;
    var show_statuses = !!document.forms.statusForm.show_statuses.checked;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/create_status.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'title=' + encodeURIComponent(title) +
        '&description=' + encodeURIComponent(description) +
        '&show_statuses=' + encodeURIComponent(show_statuses) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            if (document.getElementById("statuses").textContent.includes('компании еще нет')) {
                document.getElementById("statuses").innerHTML = `<span id="sp_${data.id}"><span title="${data.description}">${data.title}</span>` +
                    `<svg onclick="delete_status('${data.id}')" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="grey" class="bi bi-x-circle del"` +
                    `viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>` +
                    `<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0` +
                    `1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/></svg><br></span>`;
            } else {
                document.getElementById("statuses").innerHTML += `<span id="sp_${data.id}"><span title="${data.description}">${data.title}</span>` +
                    `<svg onclick="delete_status('${data.id}')" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="grey" class="bi bi-x-circle del"` +
                    `viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>` +
                    `<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0` +
                    `1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/></svg><br></span>`;
            }
        }
    }
    xhr.send(body)
    document.getElementById('st_in1').value = ""
    document.getElementById('st_in2').value = ""
}

function create_category() {
    var title = document.forms.categoryForm.title.value;
    var description = document.forms.categoryForm.description.value;
    var token = document.forms.categoryForm.authenticity_token.value;
    var show_categories = !!document.forms.categoryForm.show_categories.checked;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/create_category.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'title=' + encodeURIComponent(title) +
        '&description=' + encodeURIComponent(description) +
        '&show_categories=' + encodeURIComponent(show_categories) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            if (document.getElementById("categories").textContent.includes('еще нет категорий')) {
                document.getElementById("categories").innerHTML = `<span id="sp2_${data.id}"><span title="${data.description}">${data.title}</span>` +
                    `<svg onclick="delete_category('${data.id}')"  xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="grey" class="bi bi-x-circle del"` +
                    `viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>` +
                    `<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0` +
                    `1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/></svg><br></span>`;
            } else {
                document.getElementById("categories").innerHTML += `<span id="sp2_${data.id}"><span title="${data.description}">${data.title}</span>` +
                    `<svg onclick="delete_category('${data.id}')"  xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="grey" class="bi bi-x-circle del"` +
                    `viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>` +
                    `<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0` +
                    `1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/></svg><br></span>`;
            }
        }
    }
    xhr.send(body)
    document.getElementById('c_in1').value = ""
    document.getElementById('c_in2').value = ""
}

function none_block(name) {
    document.getElementById(name).classList.add("hidden");
}

function delete_status(id) {
    if (!confirm("Вы уверены что хотите удалить статус? Это необратимый процесс.")) {
        return
    } else {
        var xhr = new XMLHttpRequest();
        var params = 'id=' + encodeURIComponent(id);
        xhr.open("GET", "/delete_status?" + params)

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                data = JSON.parse(xhr.responseText)
                document.getElementById(`sp_${data[0]}`).style.display = 'none'
            }
        }
        xhr.send()
    }
}

function delete_category(id) {
    if (!confirm("Вы уверены что хотите удалить категорию? Это необратимый процесс.")) {
        return
    } else {
        var xhr = new XMLHttpRequest();
        var params = 'id=' + encodeURIComponent(id);
        xhr.open("GET", "/delete_category?" + params)

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                data = JSON.parse(xhr.responseText)
                document.getElementById(`sp2_${data[0]}`).style.display = 'none'
            }
        }
        xhr.send()
    }
}

function create_template() {
    var subject = document.forms.templateForm.subject.value;
    var body_email = document.forms.templateForm.body.value;
    var name = document.forms.templateForm.name.value;
    var token = document.forms.templateForm.authenticity_token.value;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/create_template.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'subject=' + encodeURIComponent(subject) +
        '&body=' + encodeURIComponent(body_email) +
        '&name=' + encodeURIComponent(name) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            document.getElementById("exist_templates").innerHTML += `<br><span id="template_${data.id}" class="template"><a href="#win100500" onclick="show_template('${data.id}')" class="one_template">${data.name}</a></span>`;
        }
    }
    xhr.send(body)
    document.forms.templateForm.subject.value = ""
    document.forms.templateForm.body.value = ""
}

$('body').on('focus', '[contenteditable]', function() {
    const $this = $(this);
    $this.data('before', $this.html());

}).on('blur', '[contenteditable]', function() {
    const $this = $(this);
    if ($this.data('before') !== $this.html()) {
        $this.data('before', $this.html());
        $this.trigger('change');

        update_template($this.attr('name'), $this.html(), $this.attr('template_id'));
    }
});

function update_template(name, value, id) {
    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/update_template.json");

    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = name + '=' + encodeURIComponent(value) +
        '&id=' + id +
        '&authenticity_token=' + document.getElementById('token').value;

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('template_alert').classList.remove('hidden')
            setTimeout(hidden_alert, 1000)
        }
    }
    xhr.send(body)

}

function hidden_alert(){
    document.getElementById('template_alert').classList.add('hidden')
}

function hidden_alert2(){
    document.getElementById('template_alert2').classList.add('hidden')
}

function delete_template(id) {
    if (!confirm("Вы уверены что хотите удалить шаблон письма? Это необратимый процесс.")) {
        return
    } else {
        var xhr = new XMLHttpRequest();
        var params = 'id=' + encodeURIComponent(id);
        xhr.open("GET", "/delete_template?" + params)

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
            }
        }
        xhr.send()
        document.getElementById(`template_${id}`).style.display = 'none'
    }
}

function set_default_template() {
    var id = document.forms.defaultTemplateForm.id.value;

    var xhr = new XMLHttpRequest();
    var params = 'id=' + encodeURIComponent(id);
    xhr.open("GET", "/set_default_template?" + params)

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('template_alert2').classList.remove('hidden')
            setTimeout(hidden_alert2, 1000)
        }
    }
    xhr.send()
}

function show_template(id) {
    var xhr = new XMLHttpRequest();
    var params = 'id=' + encodeURIComponent(id);
    xhr.open("GET", "/show_template?" + params)

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            document.getElementById('info_about_template').innerHTML =  `<span contenteditable="true" name="name" template_id="${data.id}">${data.name}</span><br><span contenteditable="true" name="subject" template_id="${data.id}">${data.subject}</span>` +
                `<xmp id='body_template' contenteditable="true" name="body" template_id="${data.id}">${data.body}</xmp><span id="delete_template" onclick="delete_template('${data.id}')">Удалить шаблон</span>`
        }
    }
    xhr.send()
}

function start_worker(){
    var xhr = new XMLHttpRequest();
    document.getElementById('menu_text333').innerText = 'Обрабатывается'
    xhr.open("GET", "/start_worker")

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('alert_worker').innerHTML = xhr.responseText;
            document.getElementById('menu_text333').innerText = 'Проверить почтовый ящик'
          }
    }
    xhr.send()
}
