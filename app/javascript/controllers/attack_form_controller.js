import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["actionType", "damageSection", "attackRoll"]

  connect() {
    this.#toggleDamage()
  }

  toggleDamage() {
    this.#toggleDamage()
  }

  #toggleDamage() {
    const type = this.actionTypeTarget.value
    const showDamage = ["attack", "spell"].includes(type)
    this.damageSectionTarget.classList.toggle("hidden", !showDamage)
  }
}
