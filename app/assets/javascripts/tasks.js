function create_task() {
    var subject = document.forms.taskForm.subject.value;
    var body2 = document.forms.taskForm.body.value;
    var until_date = document.forms.taskForm.until_date.value;
    var tag = document.forms.taskForm.tag.value;
    var user_id = document.forms.taskForm.user_id.value;
    var token = document.forms.taskForm.authenticity_token.value

    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/create_task.json")
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'subject=' + encodeURIComponent(subject) +
        '&body=' + encodeURIComponent(body2) +
        '&until_date=' + encodeURIComponent(until_date) +
        '&tag=' + encodeURIComponent(tag) +
        '&user_id=' + encodeURIComponent(user_id) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            tasks("")
        }
    }
    xhr.send(body)
    return false
}

function tasks(active) {
    var xhr = new XMLHttpRequest();
    var params = ''
    var user_id = document.getElementById('select_user').value
    var tag = document.getElementById('select_tag').value

    if (active === true || active === false){
        params+= 'active=' + encodeURIComponent(active) + '&';
        if (active === true ){
            document.getElementById('active_tasks').classList.add('i_active');
            document.getElementById('inactive_tasks').classList.remove('i_active');
            document.getElementById('all_tasks').classList.remove('i_active');
        } else {
            document.getElementById('active_tasks').classList.remove('i_active');
            document.getElementById('inactive_tasks').classList.add('i_active');
            document.getElementById('all_tasks').classList.remove('i_active');
        }
    } else {
        document.getElementById('all_tasks').classList.add('i_active');
        document.getElementById('inactive_tasks').classList.remove('i_active');
        document.getElementById('active_tasks').classList.remove('i_active');
    }

    if (user_id !== '0'){
        params+= 'user_id=' + encodeURIComponent(user_id) + '&';
    }

    if (tag !== '0'){
        params+= 'tag=' + encodeURIComponent(tag);
    }

    xhr.open("GET", "/tasks?" + params)

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)

            if (data.length == 0) {
                document.getElementById('min_tasks').innerHTML = "<span>Не найдено ни одной задачки</span>"
            } else {
                document.getElementById('min_tasks').innerHTML = ''
                let list_tasks = ``;
                for (let i = 0; i < data.length; i++){
                    list_tasks += `<div class="one-task"><span class="subject-task">${data[i][1]}</span>` +
                        `<br> <div class="body-task">${data[i][2]}</div> <div class="tag-task">${data[i][3]}</div>` +
                        `<div class="name-task">${data[i][5]}</div>`
                    if (data[i][4]) {
                        list_tasks += `<button class="button-task" onclick="inactive('${data[i][0]}')">inactive</button></div>`
                    } else {
                        list_tasks += `</div>`
                    }
                    if (i%3 === 2){
                        list_tasks += '<br><br>'
                    }
                }
                document.getElementById('min_tasks').innerHTML = list_tasks
            }
        }
    }
    xhr.send()
}

function inactive(id){
    if (!confirm('Вы уверены, что хотите сделать задачу неактивной?')){
        return
    }

    var xhr = new XMLHttpRequest();
    params = 'id=' + encodeURIComponent(id);

    xhr.open("GET", "/inactive?" + params)

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            tasks(false)
        }
    }
    xhr.send()
}
