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

});
