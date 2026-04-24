import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { content: String }

  copy() {
    navigator.clipboard.writeText(this.contentValue)
    this.#showFeedback()
  }

  #showFeedback() {
    const original = this.element.textContent
    this.element.textContent = "Copied!"
    setTimeout(() => { this.element.textContent = original }, 1500)
  }
}
