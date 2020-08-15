import { Controller } from 'stimulus';
import Sortable, { AutoScroll } from 'sortablejs/modular/sortable.core.esm.js'

const uiOptions = {
  handle: '.js-sortable-handle',
  scroll: true,
  animation: 150,
  easing: 'cubic-bezier(1, 0, 0, 1)',
  ghostClass: '.sortable-ghost'
}

export default class extends Controller {
  initialize() {
    Sortable.mount(new AutoScroll())
  }

  connect() {
    const url = this.data.get('url')
    const groupName = this.element.id

    Sortable.create(this.element, {
      ...uiOptions,
      group: {
        name: groupName,
        pull: true,
        put: true
      },
      onEnd: function(e) {
        const payload = {
          from_id: e.from.dataset.releaseId,
          item_id: e.item.dataset.itemId,
          to_id: e.to.dataset.releaseId,
          position: e.newIndex + 1
        }
        console.log(payload)
        $.ajax({ type: 'PATCH', url: url, dataType: 'json', data: payload })
      }
    })
  }
}
