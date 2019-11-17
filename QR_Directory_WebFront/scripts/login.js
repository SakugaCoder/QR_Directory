(function(){
    //Validate if the user has started the sesion
    validateLogin("login");
    //Select the login form object
    let login_form = document.getElementById("form-log-in");
    //Create a new FormData in order to send throught XMLHttp Request
    var form_data = new FormData();
    //Event listener for login form
    login_form.addEventListener("submit", (evt) => {
        //Prevent default behavior (submit form)
        evt.preventDefault();
        //Get input text data (username and pswd)
        let username = evt.target.username.value;
        let pswd = evt.target.pswd.value;
        //Append input text data into a FormData
        form_data.append("username",username);
        form_data.append("pswd",pswd);
        console.log(username);
        console.log(pswd);

        //If username and password are complete then try to login with these credentials
        if(username != "" && pswd != ""){
            console.log("Usuario y pswd completado");
            logIng(form_data);
        }

        //If password or username are imcomplete then
        else if(username == "" && pswd == ""){
            console.log("Usuario o pswd nulo");
        }
    });
}());