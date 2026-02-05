document.addEventListener("turbo:load", () => {

  const hamburger = document.getElementById("hamburger");
  const dropdown = document.getElementById("dropdown");

  if (hamburger && dropdown) {

    hamburger.addEventListener("click", (e) => {
      e.stopPropagation();
      dropdown.classList.toggle("show");
    });

    document.addEventListener("click", (e) => {
      if (!dropdown.contains(e.target) && e.target !== hamburger) {
        dropdown.classList.remove("show");
      }
    });
  }

  document.querySelectorAll(".delete-confirm").forEach(btn => {
    btn.addEventListener("click", (e) => {
      if (!confirm("Are you sure?")) {
        e.preventDefault();
      }
    });
  });

  const toast = document.getElementById("toast");

  if (toast) {
    toast.style.display = "block";
    setTimeout(() => toast.style.display = "none", 5000);
  }

    const signupForm = document.getElementById("signupForm");

    if (signupForm) {

    const email = document.getElementById("emailField");
    const password = document.getElementById("passwordField");

    const emailError = document.getElementById("emailError");
    const passwordError = document.getElementById("passwordError");

    signupForm.addEventListener("submit", function(e) {

        let valid = true;

        if (email.value.trim() === "") {
        emailError.textContent = "Email is required";
        valid = false;
        } else {
        emailError.textContent = "";
        }

        const passwordRegex =
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d])[^\s]{6,8}$/;

        if (password.value.trim() === "") {
        passwordError.textContent = "Password is required";
        valid = false;

        } else if (!passwordRegex.test(password.value)) {
        passwordError.textContent = "Password format is invalid";
        valid = false;

        } else {
        passwordError.textContent = "";
        }

        if (!valid) e.preventDefault();
    });
    }

 
    const loginForm = document.getElementById("loginForm");

    if (loginForm) {

        const email = document.getElementById("loginEmail");
        const password = document.getElementById("loginPassword");

        const emailError = document.getElementById("loginEmailError");
        const passwordError = document.getElementById("loginPasswordError");

        loginForm.addEventListener("submit", function(e) {

            let valid = true;

            if (email.value.trim() === "") {
                emailError.textContent = "Email is required";
                valid = false;
            } else {
                emailError.textContent = "";
            }

            if (password.value.trim() === "") {
                passwordError.textContent = "Password is required";
                valid = false;
            } else {
                passwordError.textContent = "";
            }

            if (!valid) {
                e.preventDefault();
            }

        });

    }

    const updateForm = document.getElementById("updatePasswordForm");

    if (updateForm) {

    const password = document.getElementById("updatePasswordField");
    const passwordError = document.getElementById("updatePasswordError");

    updateForm.addEventListener("submit", function(e) {

        let valid = true;

        const passwordRegex =
        /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d])[^\s]{6,8}$/;

        if (password.value.trim() === "") {
        passwordError.textContent = "Password is required";
        valid = false;

        } else if (!passwordRegex.test(password.value)) {
        passwordError.textContent = "Password format is invalid";
        valid = false;

        } else {
        passwordError.textContent = "";
        }

        if (!valid) e.preventDefault();
    });

    }

  const form = document.getElementById("taskForm");
  const titleField = document.getElementById("titleField");
  const titleError = document.getElementById("titleError");

  form.addEventListener("submit", function (e) {

    if (titleField.value.trim() === "") {
      e.preventDefault();
      titleError.textContent = "Title can't be blank";
      titleField.classList.add("input-error");
    } else {
      titleError.textContent = "";
      titleField.classList.remove("input-error");
    }

  });

  const editTaskForm = document.getElementById("editTaskForm");
  const editTitleField = document.getElementById("editTitleField");
  const editTitleError = document.getElementById("editTitleError");
  
  editTaskForm.addEventListener("submit", function (e) {

    if (editTitleField.value.trim() === "") {
      e.preventDefault();
      editTitleError.textContent = "Title can't be blank";
      editTitleField.classList.add("input-error");
    } else {
      editTitleError.textContent = "";
      editTitleField.classList.remove("input-error");
    }

  });

});
