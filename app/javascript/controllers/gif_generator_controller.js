import { Controller } from "@hotwired/stimulus";

// Conecta ao data-controller="gif-generator"
export default class extends Controller {
  static targets = ["image", "hiddenField"];

  connect() {
    this.apiKey = "8DvE96Bqq5E1K0QDd08Hv53sAlNCOYhx"; // Chave da API do Giphy
    this.gifUrl = `https://api.giphy.com/v1/gifs/random?api_key=${this.apiKey}&tag=funny&rating=pg-13`;
  }

  generate() {
    fetch(this.gifUrl)
        .then((response) => response.json())
        .then((data) => {
          const gifLink = data.data.images.original.url;

          // Atualiza o src da imagem exibida
          this.imageTarget.src = gifLink;

          // Atualiza o campo oculto com o link do GIF
          this.hiddenFieldTarget.value = gifLink;
        })
        .catch((error) => {
          console.error("Erro ao gerar GIF:", error);
        });
  }
}
