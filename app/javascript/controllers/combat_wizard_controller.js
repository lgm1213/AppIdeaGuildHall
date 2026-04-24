import { Controller } from "@hotwired/stimulus"

const KIND_TO_ACTION_TYPE = { weapon: "attack", spell: "spell", ability: "ability", attack: "attack" }

export default class extends Controller {
  static targets = [
    "panel",
    "actionTypeField", "targetIdField", "attackRollField",
    "hitField", "weaponNameField", "damageDealtField",
    "d20Input", "bonusDisplay", "rollSummary", "rollTotal",
    "hitBadge", "missBadge", "weaponDiceHint", "actionLabel",
    "targetAcDisplay", "saveInfo"
  ]

  static values = {
    step:        { type: Number,  default: 1 },
    prevStep:    { type: Number,  default: 1 },
    attackBonus: { type: Number,  default: 0 },
    targetAc:    { type: Number,  default: 10 },
    weaponDice:  { type: String,  default: "" },
    isAttack:    { type: Boolean, default: true },
    saveInfo:    { type: String,  default: "" }
  }

  // Step 1: Weapon, spell, or ability chosen
  chooseWeapon(event) {
    const el      = event.currentTarget
    const isSave  = el.dataset.isSave === "true"
    const kind    = el.dataset.kind || "weapon"

    this.attackBonusValue            = parseInt(el.dataset.bonus) || 0
    this.weaponDiceValue             = el.dataset.dice || ""
    this.isAttackValue               = !isSave
    this.weaponNameFieldTarget.value = el.dataset.name
    this.actionTypeFieldTarget.value = KIND_TO_ACTION_TYPE[kind] || "attack"
    this.saveInfoValue               = isSave
      ? `DC ${parseInt(el.dataset.bonus) || 0} ${(el.dataset.saveStat || "DEX").toUpperCase()} saving throw`
      : ""
    this.#setActionLabel(el.dataset.name)
    this.#goTo(2)
  }

  // Step 1: Non-attack action chosen (Dash, Dodge, Help, etc.)
  chooseAction(event) {
    const el = event.currentTarget
    this.isAttackValue               = el.dataset.attack === "true"
    this.actionTypeFieldTarget.value = el.dataset.type
    this.weaponNameFieldTarget.value = ""
    this.saveInfoValue               = ""
    this.#setActionLabel(el.dataset.label)
    this.#goTo(2)
  }

  // Step 2: Target chosen
  chooseTarget(event) {
    const el = event.currentTarget
    this.targetIdFieldTarget.value         = el.dataset.id
    this.targetAcValue                     = parseInt(el.dataset.ac) || 10
    this.targetAcDisplayTarget.textContent = el.dataset.ac || "?"
    this.#goTo(this.isAttackValue ? 3 : 4)
  }

  // Step 2: No target needed
  skipTarget() {
    this.targetIdFieldTarget.value = ""
    this.#goTo(this.isAttackValue ? 3 : 4)
  }

  // Step 3: d20 entered — auto-calculate hit/miss
  evaluateRoll() {
    const d20 = parseInt(this.d20InputTarget.value)
    if (isNaN(d20) || d20 < 1 || d20 > 20) return

    const total = d20 + this.attackBonusValue
    const hit   = d20 === 20 || (d20 !== 1 && total >= this.targetAcValue)

    this.attackRollFieldTarget.value   = total
    this.rollTotalTarget.textContent   = `${total}`
    this.hitFieldTarget.value          = hit ? "true" : "false"
    this.rollSummaryTarget.classList.remove("hidden")
    this.hitBadgeTarget.classList.toggle("hidden", !hit)
    this.missBadgeTarget.classList.toggle("hidden", hit)
  }

  confirmHit() {
    if (this.weaponDiceValue && this.hasWeaponDiceHintTarget) {
      this.weaponDiceHintTarget.textContent = this.weaponDiceValue
    }
    this.#goTo(4)
  }

  confirmMiss() {
    this.damageDealtFieldTarget.value = 0
    this.hitFieldTarget.value         = "false"
    this.element.querySelector("form").requestSubmit()
  }

  back() {
    this.#goTo(this.prevStepValue)
  }

  // Value callbacks

  stepValueChanged() {
    this.panelTargets.forEach((el, i) => {
      el.classList.toggle("hidden", i + 1 !== this.stepValue)
    })

    if (this.stepValue === 3) {
      if (this.hasD20InputTarget) this.d20InputTarget.value = ""
      if (this.hasRollSummaryTarget) this.rollSummaryTarget.classList.add("hidden")
      if (this.hasBonusDisplayTarget) {
        const b = this.attackBonusValue
        this.bonusDisplayTarget.textContent = b >= 0 ? `+${b}` : `${b}`
      }
    }

    if (this.stepValue === 4) {
      if (this.hasWeaponDiceHintTarget && this.weaponDiceValue) {
        this.weaponDiceHintTarget.textContent = this.weaponDiceValue
      }
    }
  }

  saveInfoValueChanged() {
    if (!this.hasSaveInfoTarget) return
    this.saveInfoTarget.textContent = this.saveInfoValue
    this.saveInfoTarget.classList.toggle("hidden", !this.saveInfoValue)
  }

  // Private

  #goTo(step) {
    this.prevStepValue = this.stepValue
    this.stepValue     = step
  }

  #setActionLabel(text) {
    this.actionLabelTargets.forEach(el => el.textContent = text)
  }
}
