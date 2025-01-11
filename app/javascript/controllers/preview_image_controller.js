import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview", "error"];

  updatePreview() {
    const imageUrl = this.inputTarget.value;
    if (!imageUrl) {
      this.showError("Por favor, insira uma URL válida.");
      return;
    }

    this.errorTarget.textContent = ""; // Limpa mensagens de erro anteriores
    this.previewTarget.src = imageUrl; // Atualiza o `src` da tag <img>
    this.previewTarget.onload = () => this.clearError(); // Limpa erros quando a imagem carrega
    this.previewTarget.onerror = () => this.showError("Imagem não encontrada. Verifique a URL.");
  }

  showError(message) {
    this.errorTarget.textContent = message; // Exibe mensagem de erro
    this.previewTarget.src = "https://placehold.co/500x200?text=Imagem+não+disponível"; // Exibe imagem de fallback
  }

  clearError() {
    this.errorTarget.textContent = ""; // Remove mensagem de erro
  }
}
