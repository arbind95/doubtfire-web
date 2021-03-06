angular.module('doubtfire.units.states.edit.directives.unit-details-editor', [])

#
# Editor for the basic details of a unit, such as the name, code
# start and end dates etc.
#
.directive('unitDetailsEditor', ->
  replace: true
  restrict: 'E'
  templateUrl: 'units/states/edit/directives/unit-details-editor/unit-details-editor.tpl.html'
  controller: ($scope, $state, $rootScope, DoubtfireConstants, Unit, alertService, unitService, TeachingPeriod) ->
    $scope.calOptions = {
      startOpened: false
      endOpened: false
    }

    # Get the confugurable, external name of Doubtfire
    $scope.externalName = DoubtfireConstants.ExternalName

    # get the teaching periods- gets an object with the loaded teaching periods
    $scope.teachingPeriods = TeachingPeriod.query()

    # Datepicker opener
    $scope.open = ($event, pickerData) ->
      $event.preventDefault()
      $event.stopPropagation()

      if pickerData == 'start'
        $scope.calOptions.startOpened = ! $scope.calOptions.startOpened
        $scope.calOptions.endOpened = false
      else
        $scope.calOptions.startOpened = false
        $scope.calOptions.endOpened = ! $scope.calOptions.endOpened

    $scope.dateOptions = {
      formatYear: 'yy',
      startingDay: 1
    }
    $scope.unitTypeAheadData = unitService.unitTypeAheadData
    $scope.studentSearch = ""

    $scope.saveUnit = ->
      if $scope.unit.convenors then delete $scope.unit.convenors

      if $scope.unit.start_date && $scope.unit.start_date.getMonth
        $scope.unit.start_date = "#{$scope.unit.start_date.getFullYear()}-#{$scope.unit.start_date.getMonth() + 1}-#{$scope.unit.start_date.getDate()}"
      if $scope.unit.end_date && $scope.unit.end_date.getMonth
        $scope.unit.end_date = "#{$scope.unit.end_date.getFullYear()}-#{$scope.unit.end_date.getMonth() + 1}-#{$scope.unit.end_date.getDate()}"

      if $scope.unit.teaching_period_id
        saveData = {
          name: $scope.unit.name
          code: $scope.unit.code
          description: $scope.unit.description
          teaching_period_id: $scope.unit.teaching_period_id
          active: $scope.unit.active
        }
      else
        saveData = {
          name: $scope.unit.name
          code: $scope.unit.code
          description: $scope.unit.description
          start_date: $scope.unit.start_date
          end_date: $scope.unit.end_date
          active: $scope.unit.active
        }

      if $scope.unit.id == -1
        Unit.create { unit: saveData },
          (unit) ->
            $scope.saveSuccess(unit)
          (response) ->
            alertService.add("danger", response.data.error, 6000)
      else
        Unit.update(
          {
            id: $scope.unit.id
            unit: saveData
          }, (unit) ->
            alertService.add("success", "Unit updated.", 2000)
          (response) ->
            alertService.add("danger", "Failed to update unit. #{response.data.error}", 6000)
        )

)
