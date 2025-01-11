import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toast"];

  connect() {
    // Remove o toast automaticamente após 10 segundos
    this.timeout = setTimeout(() => {
      this.close();
    }, 5000); // 10 segundos
  }

  close() {
    // Remove o elemento e cancela o timeout, se necessário
    clearTimeout(this.timeout);
    this.element.remove();
  }
}
