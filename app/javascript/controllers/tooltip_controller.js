// <div data-controller="tooltip" data-tooltip-target="element" data-bs-toggle="tooltip" data-bs-placement="top" title="Tooltip content"></div>
import { Controller } from "stimulus"
import Tooltip from 'bootstrap/js/dist/tooltip'

export default class extends Controller {
  static targets = [ "element" ]

  connect() {
    new Tooltip(this.elementTarget);
  }
}
