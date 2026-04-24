import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "entry"]
  static values  = { prefix: String }

  add() {
    const template = this.entryTargets[0]?.cloneNode(true)
    if (!template) return

    template.querySelector("textarea").value = ""
    this.containerTarget.appendChild(template)
  }

  remove(event) {
    const entry = event.target.closest("[data-entry-list-target='entry']")
    if (this.entryTargets.length > 1) {
      entry.remove()
    } else {
      entry.querySelector("textarea").value = ""
    }
  }
}
