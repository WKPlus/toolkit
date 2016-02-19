#-*- coding: utf8 -*-

'''
用来验证身份证号码是否有效的一个方法。
'''

__all__ = ['verify', 'cal_check_bit']

import operator


def cal_check_bit(sn):
    weights = [2**(18-i) for i in range(1,18)]
    _sum = sum(map(operator.mul, map(int, sn[:17]), weights)) % 11
    cb = ((10-_sum)+2) % 11
    if cb == 10:
        return 'x'
    return str(cb)


def _verify_gender(sn, gender):
    if gender is None or gender not in (0, 1):
        return True
    return (int(sn[16]) + gender) % 2 == 0


def _verify_check_bit(sn):
    return sn[17] == cal_check_bit(sn)


def verify(sn, gender=None):
    '''
    @params:
        sn: 需要验证的身份证号码
        gender: 需要验证的身份证对应人的性别
                1表示男性，0表示女性，默认为None表示不验证
    '''
    if len(sn) != 18:
        return False

    try:
        return _verify_gender(sn, gender) and _verify_check_bit(sn)
    except:
        return False
