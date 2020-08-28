import Topic from './topic';

export default class ShortDialog extends Topic {
  _type() { return 'dialog'; }
  _type_label() { return I18n.t('frontend.dynamic_elements.dialog.type_label'); } // eslint-disable-line camelcase

  initialize() {
    this._checkHeight();
    this.on('appear', this._appear);

    // по клику на Ответить помечаем сущность прочитанной
    this.$('.item-reply').on('click', () => {
      this.$('.b-new_marker.active').click();
    });
  }

  // private functions
  _checkHeight() {
    this.$inner.checkHeight({
      max_height: this.MAX_PREVIEW_HEIGHT,
      collapsed_height: this.COLLAPSED_HEIGHT
    });
  }
}
