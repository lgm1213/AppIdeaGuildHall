import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["proficiency", "bonus", "total"]
  static values  = { abilityMod: Number, profBonus: Number }

  recalculate() {
    const prof  = this.proficiencyTarget.checked ? this.profBonusValue : 0
    const bonus = parseInt(this.bonusTarget.value) || 0
    const total = this.abilityModValue + prof + bonus

    this.totalTarget.textContent = total >= 0 ? `+${total}` : `${total}`
    this.totalTarget.classList.toggle("text-primary", prof !== 0 || bonus !== 0)
    this.totalTarget.classList.toggle("text-on-surface", prof === 0 && bonus === 0)
  }
}
