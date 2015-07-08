'use strict';

var React = require('react-native/addons');
var controller = require('NativeModules').TeapotController;

var {
  Bundler,
  NavigatorIOS,
  StyleSheet,
  View,
  Text,
  TextInput,
  TouchableWithoutFeedback,
  TouchableHighlight,
  ListView,
  ListViewDataSource
} = React;

var allFiles = controller.objPaths.map(x => x.slice(x.lastIndexOf('/') + 1));
var numFiles = allFiles.length;
// Make the list longer for fun
for(var i=0; i<10; i++) {
  allFiles.push('mesh-' + i + '.obj');
}

var ObjList = React.createClass({
  getInitialState: function() {
    return {
      files: [],
      dataSource: new ListViewDataSource({
        rowHasChanged: (row1, row2) => row1 !== row2
      })
    }
  },

  getDataSource: function(files) {
    return this.state.dataSource.cloneWithRows(files);
  },

  selectModel: function(file) {
    controller.loadMesh(file);
  },

  renderRow: function(file) {
    return TouchableHighlight(
      { onPress: () => this.selectModel(file),
        underlayColor: 'rgba(0, 0, 0, .6)' },
      Text({ style: { height: 30, color: 'white' }}, file)
    );
  },

  render: function() {
    var source = this.getDataSource(this.props.files);

    return ListView({
      style: { flex: 1 },
      renderRow: this.renderRow,
      dataSource: source,
      automaticallyAdjustContentInsets: false
    });
  }
});

var App = React.createClass({
  getInitialState: function() {
    return { files: [] };
  },

  handleSearch: function(e) {
    var text = e.nativeEvent.text;
    var files = (text ?
                 allFiles.filter(x => x.indexOf(text.toLowerCase()) !== -1) :
                 []);
    this.setState({ files: files });
  },

  randomModel: function() {
    controller.loadMesh(allFiles[Math.random() * numFiles | 0]);
  },

  render: function() {
    return View(
      { style: { flex: 1 } },
      View(
        {
          style: {
            flex: 0,
            justifyContent: 'center',
            alignItems: 'center'
          }
        },
        TextInput({
          style: {
            height: 40,
            borderColor: 'white',
            borderWidth: 1,
            color: 'white',
            margin: 20
          },
          onBlur: () => this.setState({ editing: true }),
          onFocus: () => this.setState({ editing: false }),
          onChange: this.handleSearch
        })
      ),

      ObjList({ files: this.state.files }),

      View(
        {
          style: {
            backgroundColor: 'white',
            height: 50
          }
        },
        TouchableHighlight(
          { style: { flex: 1 },
            underlayColor: '#555555',
            onPress: this.randomModel },
          View({
            style: {
              flex: 1,
              alignItems: 'center',
              justifyContent: 'center'
            },
          }, Text({ style: { color: 'black' }}, "Random"))
        ),
        TouchableHighlight(
          { style: { flex: 1 },
            underlayColor: '#555555',
            onPress: controller.fly },
          View({
            style: {
              flex: 1,
              alignItems: 'center',
              justifyContent: 'center'
            },
          }, Text({ style: { color: 'black' }}, "Fly"))
        )
      )
    )
  }
});

Bundler.registerComponent('App', () => App);
module.exports = App;
