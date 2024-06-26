// HomeScreen.tsx
import React from 'react';
import { StackNavigationProp } from '@react-navigation/stack';
import { RootStackParamList } from 'navigations/AppNavigator';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useNavigation } from '@react-navigation/native';


const HomeScreen: React.FC<StackNavigationProp<RootStackParamList>> = ({ }) => { // Thêm navigation props từ React Navigation
  const navigation = useNavigation<StackNavigationProp<RootStackParamList>>();  // Lấy navigation từ hook

  return (
    <View style={styles.container}>
      <Text style={styles.appNameText}>Tên Ứng Dụng</Text>

      <TouchableOpacity
        style={styles.button}
        onPress={() => navigation.navigate('CreateWallet')} // Mở CreateWalletScreen
      >
        <Text style={styles.buttonText}>Create New Wallet</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.button}
        onPress={() => navigation.navigate('ImportWallet')} // Mở ImportWalletScreen
      >
        <Text style={styles.buttonText}>Add Existing Wallet</Text>
      </TouchableOpacity>

      <Text style={styles.termsText}>
        By continuing, you agree to our <Text style={styles.termsLink}>Terms of Service</Text>
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  textContainer: { // Style cho View bao quanh text
    alignItems: 'center', // Căn giữa text theo chiều ngang
    marginBottom: 30,   // Khoảng cách với các nút bên dưới
  },
  appNameText: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 30, // Khoảng cách với các nút bên dưới
  },
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  imagePlaceholder: {
    width: 200,
    height: 200,
    backgroundColor: '#f0f0f0',
    marginBottom: 30,
  },
  button: {
    backgroundColor: '#673ab7', // Màu tím chủ đạo
    padding: 15,
    borderRadius: 8,
    width: '100%',
    marginBottom: 15,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  socialButtons: {
    flexDirection: 'row',
  },
  socialIcon: {
    width: 40,
    height: 40,
    marginHorizontal: 10,
  },
  termsText: {
    fontSize: 12,
    color: '#888',
    marginTop: 20,
  },
  termsLink: {
    textDecorationLine: 'underline',
  },
});

export default HomeScreen;

