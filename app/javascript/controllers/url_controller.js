import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  handleChange() {
    const currentValue      = this.inputTarget.value
    const formattedValue    = this.formatUrl(currentValue)
    this.inputTarget.value  = formattedValue
  }

  formatUrl(url) {
    return !/^https?:\/\//i.test(url) ? `http://${url}` : url;
  }

}
