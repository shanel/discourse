import computed from "ember-addons/ember-computed-decorators";
const { get } = Ember;

export default Ember.Controller.extend({
  filter: null,

  @computed("model.[]", "filter")
  filterReports(reports, filter) {
    if (filter) {
      return reports.filter(report => {
        return (
          (get(report, "title") || "").indexOf(filter) > -1 ||
          (get(report, "description") || "").indexOf(filter) > -1
        );
      });
    }
    return reports;
  },

  actions: {
    filterReports(filter) {
      Ember.run.debounce(this, this._performFiltering, filter, 250);
    }
  },

  _performFiltering(filter) {
    this.set("filter", filter);
  }
});
