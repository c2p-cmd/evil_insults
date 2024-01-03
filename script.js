let apiUrl = "https://evilinsult.com/generate_insult.php";

const languagePicker = document.getElementById("language-picker");
const fetchButton = document.getElementById("fetch-button");
const responseDiv = document.getElementById("response");

fetchButton.addEventListener("click", fecthAndShow);

async function fecthAndShow() {
  try {
    const selectedLanguage = languagePicker.value;

    if (!selectedLanguage) {
      // No language selected, display an error message
      alert("Please select a language.");
      return;
    }

    const response = await fetch(`${apiUrl}?lang=${selectedLanguage}`);

    const data = await response.json();
    responseDiv.textContent = data["insult"] + "\n\r" + data["createdby"];
  } catch (error) {
    console.error("Error fetching data:", error);
    responseDiv.textContent = "Error fetching data.";
  }
}
