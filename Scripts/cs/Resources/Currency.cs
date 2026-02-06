using Godot;
using System;

[GlobalClass]
public partial class Currency : Resource
{
    [Signal] public delegate void ValueChangedEventHandler();
    [Export] private float _value;
    [Export] public float pending_value;
    [Export] public CurrencyType type;
    public float Value
    {
        get => _value;
        set
        {
            _value = Mathf.Clamp(value, -10, type.limit > 0? type.limit : float.PositiveInfinity);
            EmitSignal(SignalName.ValueChanged);
        }
    }
    private float buff = 1;


    public Currency() {}
    public static Currency Create(CurrencyType _type)
    {
        return new(_type);
    }
    public Currency(CurrencyType _type)
    {
        type = _type;
    }
    public Currency(float _value, CurrencyType _type)
    {
        Value = _value;
        type = _type;
    }

    public bool has_limit() => type.limit > 0;

    public void ApplyPending()
    {
        Value += pending_value;
        //pending_value = 0f;
    }
    
    public override string ToString()
    {
        if(type == null) 
        {
            GD.PushError("No type: ", type);
            return "NullType";
        }
        return type.get_text(this);
    }

    public string AsString(int size)
    {
        if(type == null) 
        {
            GD.PushError("No type: ", type);
            return "NullType";
        }
        return type.get_text(this, size);
    }

    public string get_only_value()
    {
        return $"{MathF.Floor(Value * type.floor_coef) / type.floor_coef}[img=,32]{type.texture}[/img]";
    }

    public void BuffPending(float newBuff)
    {
        pending_value /= buff == 0 ? 1 : buff;
        buff = 1 + newBuff * type.buff_influence;
        pending_value *= buff;
    }

    public bool equals_currency(CurrencyType _type) => type == _type;

    #region Operators

    public static implicit operator float(Currency v)
    {
        return v.Value;
    }

    public static Currency operator +(Currency a, Currency b)
    {
        return new((float)a + b, a.type);
    }

    public static Currency operator -(Currency a, Currency b)
    {
        return new((float)a - b, a.type);
    }

    public static Currency operator -(Currency a)
    {
        return new(-(float)a, a.type);
    }


    public static bool operator ==(Currency a, Currency b)
    {
        if (a is null && b is null) return true;
        return a.Equals(b);
    }

    public static bool operator !=(Currency a, Currency b)
    {
        if (a is null && b is null) return false;
        return !a.Equals(b);
    }

    public override bool Equals(object obj)
    {
        if (ReferenceEquals(this, obj))
        {
            return true;
        }

        if (obj is null)
        {
            return false;
        }

        if (obj is Currency cv)
        {
            bool v = Value == cv.Value;
            bool d = type == cv.type;
            return v && d;
        }

        return false;
    }
    public override int GetHashCode() => HashCode.Combine(Value, type.GetHashCode());
    #endregion
}
