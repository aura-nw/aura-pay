import React, { useEffect } from 'react';
import { StyleSheet, Text, View } from 'react-native'; // Import Text từ 'react-native'
import BootSplash from 'react-native-bootsplash';

const SplashScreen: React.FC = () => {
  useEffect(() => {
    const init = async () => {
      // … Khởi tạo ứng dụng ở đây (ví dụ: kiểm tra đăng nhập, tải dữ liệu)
      await BootSplash.hide({ fade: true }); // Ẩn splash screen
    };

    init();
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Splash Screen</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff', // Hoặc màu nền phù hợp với splash screen của bạn
  },
  image: {
    width: 200, // Điều chỉnh kích thước theo nhu cầu
    height: 200,
  },
    title: {
        fontSize: 20,
        fontWeight: 'bold',
    },
});

export default SplashScreen;