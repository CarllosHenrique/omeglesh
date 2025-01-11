import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "previewContainer"]; // Certifique-se de que previewContainer está aqui

  connect() {
    this.hidePreview(); // Garante que o preview esteja oculto ao carregar a página
  }

  previewFiles(event) {
    const files = event.target.files;
    const previewContainer = this.previewContainerTarget;

    previewContainer.innerHTML = ''; // Limpa o preview antigo

    // Exibe o preview se houver arquivos selecionados
    if (files.length > 0) {
      previewContainer.style.display = "inline-flex"; // Exibe o preview
      for (const file of files) {
        const reader = new FileReader();

        reader.onload = () => {
          const imagePreview = document.createElement('img');
          imagePreview.src = reader.result;
          previewContainer.appendChild(imagePreview);
        };

        reader.readAsDataURL(file);
      }
    } else {
      this.hidePreview(); // Oculta o preview se não houver arquivos
    }
  }

  hidePreview() {
    this.previewContainerTarget.style.display = "none"; // Oculta o container de preview
  }

  hidePreviewAfterSubmit() {
    this.hidePreview(); // Esconde o preview quando o formulário for enviado
  }
}