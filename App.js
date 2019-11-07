/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

/* eslint-disable */
import React from 'react';
import { StyleSheet, ScrollView, View, Image } from 'react-native';

const uri = "https://cdn1-www.dogtime.com/assets/uploads/2011/03/puppy-development.jpg";
const App = () => {
    const images = [...new Array(1000)].map((_, i) => (
        <Image key={`puppy${i}`} style={{ height: 100, width: 100 }} source={{ uri }} />
    ));
    return (
        <View>
            <ScrollView>
                {images}
            </ScrollView>
        </View>
    );
};

const styles = StyleSheet.create({});

export default App;
