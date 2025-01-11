import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this));
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.clear();
      this.scrollToBottom();
    }
  }

  clear() {
    this.element.reset();
  }

  scrollToBottom() {
    const messagesContainer = document.getElementById("messages");
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
  }
}