/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */import React, { Component, PropTypes } from 'react';
 import {
   AppRegistry,
   StyleSheet,
   View,
   requireNativeComponent
 } from 'react-native';

 const NativeImageView = requireNativeComponent('LTPerspectiveImageView', PerspectiveImage);

 export default class PerspectiveImage extends Component {
   static propTypes = {
     offset: PropTypes.number,
     uri: PropTypes.string.isRequired
   };

   props: PropsType;

   constructor(props) {
     super(props);
   }

   setNativeProps(props: PropsType) {
     this.refs.self.setNativeProps(props);
   }

   render() {
     const {
       offset,
       uri,
       ...otherProps
     } = this.props;

     return (
       <NativeImageView offset={ offset || 5 } uri={uri} ref='self' {...otherProps} />
     )
   }
 }

 AppRegistry.registerComponent('PerspectiveImage', () => PerspectiveImage);
