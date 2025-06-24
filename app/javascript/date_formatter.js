function formatDates() {
  const dateElements = document.querySelectorAll("[data-format-date]");

  dateElements.forEach((element) => {
    const isoDate = element.textContent.trim();
    if (isoDate) {
      const date = new Date(isoDate);
      element.textContent = date.toLocaleDateString("en-US", {
        year: "numeric",
        month: "long",
        day: "2-digit",
      });
    }
  });
}

document.addEventListener("DOMContentLoaded", formatDates);
